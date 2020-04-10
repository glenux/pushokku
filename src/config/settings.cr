
require "yaml"

class ScriptLocalConfigSettings
  YAML.mapping(
    path: String
  )
end

class MysqlDumpLocalConfigSettings
  YAML.mapping(
    path: String
  )
end

class DockerImageLocalConfigSettings
  YAML.mapping(
    name: String
  )
end

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

class TransferDeploymentConfigSettings
  YAML.mapping(
    from: EndpointConfig,
    to: EndpointConfig,
    filters: Array(FilterConfig)?
  )
end

class RunDeploymentConfigSettings
  YAML.mapping(
    from: EndpointConfig,
    to: EndpointConfig,
  )
end
