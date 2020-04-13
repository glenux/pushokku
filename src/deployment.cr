
require "./deployment/*"
# run_script_to_dokku_app"
# require "./deployment/transfer_docker_image_to_dokku_app"
# require "./deployment/transfer_mysql_dump_to_dokku_mariadb"


class Deployment
  def self.apply_config!(config)
    config.deployments.each do |deployment_config|
      Deployment.apply_deployment!(config, deployment_config)
    end
  end

  def self.apply_deployment!(config : Config, deployment_config : TransferDeploymentConfig) 
    src = config.find_endpoint(deployment_config.transfer.src)
    dest = config.find_endpoint(deployment_config.transfer.dest)

    puts "Trying TransferDeploymentConfig: #{src.class} --> #{dest.class}..."
    self.apply_transfer!(config, src, dest)
  end

  def self.apply_deployment!(config : Config, deployment_config : RunDeploymentConfig) 
    src = config.find_endpoint(deployment_config.run.src)
    dest = config.find_endpoint(deployment_config.run.dest)
    puts "Trying RunDeploymentConfig: #{src.class} --> #{dest.class}..."

    self.apply_run!(config, src, dest)
  end

  def self.apply_run!(config, src, dest)
    puts "WARNING: run #{src.class} --> #{dest.class} missing!".colorize(:yellow)
  end

  def self.apply_transfer!(config, src, dest)
    puts "WARNING: transfer #{src.class} --> #{dest.class} missing!".colorize(:yellow)
  end

  def something
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
end

