
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

class ScriptLocalConfig
  YAML.mapping(
    name: String,
    script: ScriptLocalConfigSettings
  )
end

class MysqlDumpLocalConfig
  YAML.mapping(
    name: String,
    mysql_dump: MysqlDumpLocalConfigSettings
  )
end

class DockerImageLocalConfig
  YAML.mapping(
    name: String,
    docker_image: DockerImageLocalConfigSettings
  )
end

alias LocalConfig =
  DockerImageLocalConfig |
  MysqlDumpLocalConfig |
  ScriptLocalConfig

