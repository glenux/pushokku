
require "yaml"

class DokkuMariadbConfig
  YAML.mapping(
    name: String,
    options: YAML::Any | Nil
  )
end

class DokkuAppConfig
  YAML.mapping(
    name: String,
    options: YAML::Any | Nil
  )
end

class DeploymentMariadbConfig
  YAML.mapping(
    local: String,
    remote: String,
    dokku_mariadb: DokkuMariadbConfig,
  )
end

class DeploymentAppConfig
  YAML.mapping(
    local: String,
    remote: String,
    dokku_app: DokkuAppConfig,
  )
end

alias DeploymentConfig = 
  DeploymentMariadbConfig | 
  DeploymentAppConfig

