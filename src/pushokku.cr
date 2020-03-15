# file: help.cr
require "option_parser"
require "yaml"
require "colorize"

require "./config"
require "./deployment"

module Pushokku
  class Cli
    alias Options = {
      config_file: String,
      docker_compose_yml: String,
      environment: String
    }

    def parse_options(args) : Options
      config_file = ".pushokku.yml"
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
      puts "Loading configuration...".colorize(:yellow)
      if ! File.exists? config_file 
        STDERR.puts "ERROR: Unable to read configuration file '#{config_file}'"
        exit 1
      end

      yaml_str = File.read(config_file)
      config = Config.from_yaml(yaml_str)
      # yaml = YAML.parse(yaml_str)

      if config.nil?
        STDERR.puts "ERROR: Invalid YAML content in '#{config_file}'"
        exit 1
      end

      return config
    end


    def self.run(args) 
      app = Cli.new
      opts = app.parse_options(args)
      config = app.load_config(opts["config_file"])
      # env_config = App.get_config(config, opts["environment"])

      deployment_classes = [ 
        DockerImageToDokkuApp,
        MysqlDumpToDokkuMariadb
      ]

      config.deployments.each do |deployment|
        local = config.locals.select { |l| l.name == deployment.local }.first
        remote = config.remotes.select { |r| r.name == deployment.remote }.first
        if local.nil?
          puts "Unknown local #{deployment.local}. Exiting."
          exit 2
        end
        if remote.nil?
          puts "Unknown remote #{deployment.remote}. Exiting."
          exit 2
        end

        deployment_handler = "#{local.type}_to_#{deployment.type}"
        deployment_class = deployment_classes.select {|c| c.handler == deployment_handler }.first
        if deployment_class.nil? 
          puts "Unknown deloyment class for #{deployment_handler}. Exiting."
          exit 2
        end

        deployment = deployment_class.new(local, remote, deployment)
        deployment.run
        # puts deployment.inspect
      end

      exit 2
    end
  end
end

Pushokku::Cli.run(ARGV)

