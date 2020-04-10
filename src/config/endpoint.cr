
require "yaml"

class ScriptEndpointConfig
  YAML.mapping(
    name: String,
    script: ScriptEndpointConfigSettings
  )
end

class MysqlDumpEndpointConfig
  YAML.mapping(
    name: String,
    mysql_dump: MysqlDumpEndpointConfigSettings
  )
end

class DockerImageEndpointConfig
  YAML.mapping(
    name: String,
    docker_image: DockerImageEndpointConfigSettings
  )
end

alias EndpointConfig =
  DockerImageEndpointConfig |
  MysqlDumpEndpointConfig |
  ScriptEndpointConfig

