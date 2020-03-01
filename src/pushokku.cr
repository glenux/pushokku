# file: help.cr
require "option_parser"
require "yaml"

class Pushokku
  alias Options = {
    config_file: String,
    docker_compose_yml: String,
    environment: String
  }

  alias Config = {
    host: String,
    service: String,
    app: String
  }

  def parse_options(args) : Options
    config_file = ".pushokku"
    docker_compose_yml = "docker-compose.yml"
    environment = "production"
    
    OptionParser.parse(args) do |parser|
      parser.banner = "Welcome to Pushokku!"

      parser.on "-c CONFIG", "--config=CONFIG", "Use the following config file" do |file|
        config_file = file
      end

      parser.on "-f DOCKER_COMPOSE_YML", "--config=DOCKER_COMPOSE_YML", "Use the following docker-compose file" do |file|
        docker_compose_yml = file
      end

      parser.on "-v", "--version", "Show version" do
        puts "version 1.0"
        exit
      end
      parser.on "-h", "--help", "Show help" do
        puts parser
        exit
      end
    end
    return { 
      docker_compose_yml: docker_compose_yml,
      config_file: config_file,
      environment: environment
    }
  end

  def load_config(config_file : String) : Config
    if ! File.exists? config_file 
      STDERR.puts "ERROR: Unable to read configuration file '#{config_file}'"
      exit 1
    end

    yaml = File.open(config_file) do |file|
      YAML.parse(file)
    end

    { 
      host: yaml["host"].to_s,
      service: yaml["service"].to_s,
      app: yaml["app"].to_s
    }
  end

  def image_tag(docker_compose_yml : String, service : String, app : String)
    version = `date +"v%Y%m%d_%H%M"`.strip
    tag_name = "dokku/#{app}"
    tag_name_version = "#{tag_name}:#{version}"
    image = `docker-compose -f #{docker_compose_yml} images -q #{service} `.strip
    Process.run "docker", ["tag", image, tag_name_version]

    res = {
      version: version,
      tag_name_version: tag_name_version
    }
    puts YAML.dump({ image_tag: res })
    puts "---"
    return res
  end

  def image_push(host, tag_name_version)
    # docker save "$TAG_NAME_VERSION" \
    #     | gzip \
    #     | ssh "$HOST_REMOTE" "gunzip | docker load"


    pipe1_reader, pipe1_writer = IO.pipe(true)
    pipe2_reader, pipe2_writer = IO.pipe(true)

    p3_out = IO::Memory.new
    p3_err = IO::Memory.new
    p3 = Process.new "ssh", [host, "gunzip | docker load"], 
      input: pipe2_reader, output: p3_out, error: p3_err

    p2_err = IO::Memory.new
    p2 = Process.new "gzip",
      input: pipe1_reader, 
      output: pipe2_writer,
      error: p2_err
    
    p1_err = IO::Memory.new
    p1 = Process.new "docker", ["save", tag_name_version], 
      output: pipe1_writer, 
      error: p1_err

    status = p1.wait
    pipe1_writer.close
    if status.success? 
      puts "Docker image successfully exported"
    else 
      STDERR.puts "Error when exporting docker image!"
      STDERR.puts "- exit status: #{status.exit_status}"
      STDERR.puts "- err: #{p1_err}"
      exit 1
    end

    status = p2.wait
    pipe1_reader.close
    pipe2_writer.close
    if ! status.success?
      STDERR.puts "Error when gzipping image!"
      STDERR.puts "- exit status: #{status.exit_status}"
      STDERR.puts "- err: #{p2_err}"
    end

    status = p3.wait
    pipe2_reader.close
    if status.success?
      puts "Docker image successfully imported on #{host}"
      # puts "- out : #{p3_out}"
    else
      STDERR.puts "Error when importing docker image!"
      STDERR.puts "- exit status: #{status.exit_status}"
      STDERR.puts "- err: #{p3_err}"
    end
  end

  def image_deploy(host, app, version)
    Process.run "ssh", [host, "dokku tags:deploy #{app} #{version}"]
  end

  def self.run(args) 
    app = Pushokku.new
    opts = app.parse_options(args)
    config = app.load_config(opts["config_file"])
    # env_config = App.get_config(config, opts["environment"])
    image_meta = app.image_tag(opts["docker_compose_yml"], config["service"], config["app"])
    app.image_push(config["host"], image_meta["tag_name_version"])
    app.image_deploy(config["host"], config["app"], image_meta["tag_name_version"])
  end
end

Pushokku.run(ARGV)

