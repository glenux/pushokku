
class Deployment

  def self.apply_transfer!(
    config : Config, 
    src : MysqlDumpEndpointConfig, 
    dest : DokkuMariadbEndpointConfig 
  )
    dokku_mariadb = dest.name
    # local_path = @local.path
    # puts @local.inspect
    # file_push(@remote.host, local_path, dokku_mariadb.name)
  end

  private def file_push(host, local_path, dokku_mariadb_name)
    # cat database.sql \
    #     | ssh SERVER 'dokku mariadb:import DATABASE'

    pipe1_reader, pipe1_writer = IO.pipe(true)

    proc2_out = IO::Memory.new
    puts "Pushing data...".colorize(:yellow)
    p2 = Process.new "ssh", [host, "dokku mariadb:import #{dokku_mariadb_name}"], 
      input: pipe1_reader, output: proc2_out, error: STDERR

    p1 = Process.new "cat", [local_path.to_s],
      output: pipe1_writer, 
      error: STDERR

    status = p1.wait
    pipe1_writer.close
    if status.success? 
      puts "-----> Database file successfully sent"
    else 
      STDERR.puts "Error (code #{status.exit_status}) when deploying docker image!"
      exit 1
    end

    status = p2.wait
    pipe1_reader.close
    if status.success? 
      puts "-----> Database file successfully deployed"
    else 
      STDERR.puts "Error (code #{status.exit_status}) when deploying docker image!"
      exit 1
    end

    puts "Image pushed successfully!".colorize(:green)
  end
end

