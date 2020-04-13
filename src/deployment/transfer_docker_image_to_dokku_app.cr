
require "colorize"

class Deployment
  # puts YAML.dump({ image_tag: res })
  # puts "---"

  def self.apply_transfer!(
    config : Config, 
    src : DockerImageEndpointConfig, 
    dest : DokkuAppEndpointConfig 
  )
    src_host = config.find_host(src.host)
    dest_host = config.find_host(dest.host)

    pp src 
    dest_docker_image = build_docker_image_ref_timestamp(dest.name)
    docker_image_tag!(src, dest_docker_image)
    docker_image_push!(dest, src, dest_docker_image, dest_host)
    # docker_image_deploy!(dest_host, dest_docker_image, dest_host)
  end

  private def self.build_docker_image_ref_timestamp(
    dokku_app : String
  )
    dest_ref = DockerImageEndpointConfigSettings.new(
      name: "dokku/#{dokku_app}",
      tag: `TZ=UTC date +"v%Y%m%d_%H%M"`.strip
    )
    return dest_ref
  end


 #  private def self.docker_image_push!(
 #  )
 #    STDERR.puts "ERROR: pushing docker images to local host is not implemented"
 #    exit 2
 #  end


  private def self.docker_image_tag!(
    src : DockerImageEndpointConfig, 
    dest_docker_image : DockerImageEndpointConfigSettings, 
  )
    puts "Tagging image...".colorize(:yellow)
    puts YAML.dump({ 
      src: src.docker_image.to_s, 
      dest: dest_docker_image.to_s 
    })
  end

  # docker tag ... dokku/...:tag
  # docker save "$TAG_NAME_VERSION" \
  #     | gzip \
  #     | ssh "$HOST_REMOTE" "gunzip | docker load"
  private def self.docker_image_push!(
    dest : DokkuAppEndpointConfig,
    src : DockerImageEndpointConfig, 
    dest_docker_image : DockerImageEndpointConfigSettings, 
    dest_host : HostConfig,
  )
    if dest_host.is_a? LocalHostConfig 
      return
    end

    Process.run "docker", ["tag", src.docker_image.to_s, dest_docker_image.to_s]

    pipe1_reader, pipe1_writer = IO.pipe(true)
    pipe2_reader, pipe2_writer = IO.pipe(true)

    p3_out = IO::Memory.new
    puts "Pushing image...".colorize(:yellow)
    p3 = Process.new "ssh", [dest_host.ssh.to_s, "gunzip | docker load"], 
      input: pipe2_reader, output: p3_out, error: STDERR

    p2 = Process.new "gzip",
      input: pipe1_reader, 
      output: pipe2_writer,
      error: STDERR

    p1 = Process.new "docker", ["save", src.docker_image.to_s], 
      output: pipe1_writer, 
      error: STDERR

    status = p1.wait
    pipe1_writer.close
    if status.success? 
      puts "-----> Docker image successfully exported"
    else 
      STDERR.puts "Error (code #{status.exit_status}) when exporting docker image!"
      exit 1
    end

    status = p2.wait
    pipe1_reader.close
    pipe2_writer.close
    if ! status.success?
      STDERR.puts "Error (code #{status.exit_status}) when gzipping image!"
    end

    status = p3.wait
    pipe2_reader.close
    if status.success?
      puts "-----> Docker image successfully imported on #{dest_host.ssh.to_s}"
    else
      STDERR.puts "Error (code #{status.exit_status}) when importing docker image!"
    end
    puts "Image pushed successfully!".colorize(:green)
  end

  private def self.docker_image_deploy!(
    src : DockerImageEndpointConfig, 
    dest : DockerImageEndpointConfig,
    dest_docker_image : DockerImageEndpointConfigSettings, 
  )
    puts "Deploying image #{app}:#{version}...".colorize(:yellow)
    status = Process.run "ssh", [dest.host.to_s, "dokku tags:deploy #{app} #{version}"],
      output: STDOUT, error: STDOUT
    if status.success?
      puts "Image deployed successfully!".colorize(:green)
    else
      STDERR.puts "Error (code #{status.exit_status}) when deploying image!"
    end
  end
end
