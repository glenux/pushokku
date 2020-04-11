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


    def self.handle_deployment(config : Config, deployment_config : DeploymentConfig) 
        local = config.locals.select { |l| l.name == deployment_config.local }.first
        remote = config.remotes.select { |r| r.name == deployment_config.remote }.first

        if local.nil?
          puts "Unknown local #{deployment_config.local}. Exiting."
          exit 2
        end

        if remote.nil?
          puts "Unknown remote #{deployment_config.remote}. Exiting."
          exit 2
        end

        deployment = 
          case deployment_config
          when DokkuAppDeploymentConfig then
            DockerImageToDokkuAppDeployment.new(
              local.as(DockerImageLocalConfig), 
              remote, 
              deployment_config.as(DokkuAppDeploymentConfig)
            )
          when MysqlDumpToDokkuMariadbDeployment then
            DeploymentMariadb.new(
              local.as(MysqlDumpLocalConfig), 
              remote, 
              deployment_config.as(DokkuMariadbDeploymentConfig)
            )
          when Nil
            nil
          end

        next if deployment.nil?
        deployment.run
    end


    def self.find_filter(config, name)
      matches = config.filters.select { |filter| filter.name == name }
      if matches.size > 1 
        raise "Multiple filters have the same name (unicity)"
      end
      return matches.first
    end

    def self.validate_config!(config)
      pp config
      #config.deployments.each do |deployment_config|
        # handle_deployment(config, deployment_config)
      #end
    end

    def self.apply_config!(config)
      config.deployments.each do |deployment_config|
        # handle_deployment(config, deployment_config)
      end
    end

    def self.run(args) 
      app = Cli.new
      opts = app.parse_options(args)
      config = app.load_config(opts["config_file"])
      # env_config = App.get_config(config, opts["environment"])

      validate_config!(config)
      apply_config!(config)

      exit 0
    end
  end
end

Pushokku::Cli.run(ARGV)

