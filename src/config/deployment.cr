
require "yaml"

class DokkuMariadbDeploymentConfigSettings
  YAML.mapping(
    name: String,
    options: YAML::Any | Nil
  )
end

class DokkuAppDeploymentConfigSettings
  YAML.mapping(
    name: String,
    options: YAML::Any | Nil
  )
end

class DokkuMariadbDeploymentConfig
  YAML.mapping(
    local: String,
    remote: String,
    dokku_mariadb: DokkuMariadbDeploymentConfigSettings,
  )
end

class DokkuAppDeploymentConfig
  YAML.mapping(
    local: String,
    remote: String,
    dokku_app: DokkuAppDeploymentConfigSettings,
  )
end

alias DeploymentConfig = 
  DokkuMariadbDeploymentConfig | 
  DokkuAppDeploymentConfig

