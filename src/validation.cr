
class Validation
  def self.validate_config!(config)
    pp config
    config.deployments.each do |deployment_config|
      Validation.validate_deployment!(config, deployment_config)
    end
  end

  def self.validate_deployment!(config : Config, deployment : DeploymentConfig)
    STDERR.puts "WARNING: validation for #{deployment.class} not yet implemented".colorize(:yellow)
  end
end

