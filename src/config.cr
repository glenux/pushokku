
require "yaml"
require "./config/local"
require "./config/remote"
require "./config/deployment"

class Config
  YAML.mapping(
    locals: Array(LocalConfig),
    remotes: Array(RemoteConfig),
    deployments: Array(DeploymentConfig)
  )
end


