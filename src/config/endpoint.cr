
require "yaml"
require "./endpoint_settings"


class DokkuMariadbEndpointConfig
  YAML.mapping(
    name: String,
    host: String,
    dokku_mariadb: DokkuMariadbEndpointConfigSettings
  )
end

class DokkuAppEndpointConfig
  YAML.mapping(
    name: String,
    host: String,
    dokku_app: DokkuAppEndpointConfigSettings
  )
end

class ScriptEndpointConfig
  YAML.mapping(
    name: String,
    host: String,
    script: ScriptEndpointConfigSettings
  )
end

class MysqlDumpEndpointConfig
  YAML.mapping(
    name: String,
    host: String,
    mysql_dump: MysqlDumpEndpointConfigSettings
  )
end

class DockerImageEndpointConfig
  YAML.mapping(
    name: String,
    host: String,
    docker_image: DockerImageEndpointConfigSettings
  )
end

alias EndpointConfig =
  DockerImageEndpointConfig |
  MysqlDumpEndpointConfig |
  ScriptEndpointConfig |
  DokkuAppEndpointConfig |
  DokkuMariadbEndpointConfig

