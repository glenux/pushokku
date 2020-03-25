
require "yaml"
require "./local"
require "./remote"
require "./deployment"

class Config
  YAML.mapping(
    version: String,
    locals: Array(LocalConfig),
    remotes: Array(RemoteConfig),
    deployments: Array(DeploymentConfig)
  )
end
