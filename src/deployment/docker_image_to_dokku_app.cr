
require "colorize"

class DeploymentApp
  def initialize(@local : LocalDockerConfig, @remote : RemoteConfig, @deployment : DeploymentAppConfig)
  end

  def run
    dokku_app = @deployment.as(DeploymentAppConfig).dokku_app
    app = dokku_app.name
    image_meta = image_tag(@local.docker_image, app)
    image_push(@remote.host, image_meta["tag_name_version"])
    image_deploy(@remote.host, image_meta["app"], image_meta["version"])
  end

  # private def image_tag(docker_compose_yml : String, service : String, app : String)
  #   version = `date +"v%Y%m%d_%H%M"`.strip
  #   tag_name = "dokku/#{app}"
  #   tag_name_version = "#{tag_name}:#{version}"
  #   image = `docker-compose -f #{docker_compose_yml} images -q #{service} `.strip
  #   Process.run "docker", ["tag", image, tag_name_version]

  #   res = {
  #     app: app,
  #     version: version,
  #     tag_name_version: tag_name_version
  #   }
  #   puts YAML.dump({ image_tag: res })
  #   puts "---"
  #   return res
  # end

  private def image_tag(docker_image : String, app : String)
    version = `date +"v%Y%m%d_%H%M"`.strip
    tag_name = "dokku/#{app}"
    tag_name_version = "#{tag_name}:#{version}"
    Process.run "docker", ["tag", docker_image, tag_name_version]

    res = {
      app: app,
      version: version,
      tag_name_version: tag_name_version
    }
    puts YAML.dump({ image_tag: res })
    puts "---"
    return res
  end

  private def image_push(host, tag_name_version)
    # docker save "$TAG_NAME_VERSION" \
    #     | gzip \
    #     | ssh "$HOST_REMOTE" "gunzip | docker load"

    pipe1_reader, pipe1_writer = IO.pipe(true)
    pipe2_reader, pipe2_writer = IO.pipe(true)

    p3_out = IO::Memory.new
    puts "Pushing image...".colorize(:yellow)
    p3 = Process.new "ssh", [host, "gunzip | docker load"], 
      input: pipe2_reader, output: p3_out, error: STDERR

    p2 = Process.new "gzip",
      input: pipe1_reader, 
      output: pipe2_writer,
      error: STDERR

    p1 = Process.new "docker", ["save", tag_name_version], 
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
      puts "-----> Docker image successfully imported on #{host}"
    else
      STDERR.puts "Error (code #{status.exit_status}) when importing docker image!"
    end
    puts "Image pushed successfully!".colorize(:green)
  end

  private def image_deploy(host, app, version)
    puts "Deploying image #{app}:#{version}...".colorize(:yellow)
    status = Process.run "ssh", [host, "dokku tags:deploy #{app} #{version}"],
      output: STDOUT, error: STDOUT
    if status.success?
      puts "Image deployed successfully!".colorize(:green)
    else
      STDERR.puts "Error (code #{status.exit_status}) when deploying image!"
    end
  end
end
