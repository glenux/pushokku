
require "yaml"

class RunDeploymentConfig
  YAML.mapping(
    name: String?,
    run: RunDeploymentConfigSettings
  )
end

class TransferDeploymentConfig
  YAML.mapping(
    name: String?,
    transfer: TransferDeploymentConfigSettings
  )
end

alias DeploymentConfig = 
  TransferDeploymentConfig |
  RunDeploymentConfig
