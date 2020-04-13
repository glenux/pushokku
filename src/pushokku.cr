# file: help.cr
require "option_parser"
require "yaml"
require "colorize"

require "./config"
require "./validation"
require "./deployment"

module Pushokku
  class Cli
    alias Options = {
      config_file: String,
      docker_compose_yml: String,
      environment: String
    }

    @config : Config?
    @options : Options?

    def initialize
      @options = nil
      @config = nil
    end

    def parse_options(args) : Options
      docker_compose_yml = "docker-compose.yml"
      config_file = ".pushokku.yml"
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
      @options = { 
        docker_compose_yml: docker_compose_yml,
        config_file: config_file,
        environment: environment
      }
      return @options.as(Options)
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

      Validation.validate_config!(config)
      Deployment.apply_config!(config)
      exit 0
    end
  end
end

Pushokku::Cli.run(ARGV)

