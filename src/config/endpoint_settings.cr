
require "yaml"

class DokkuMariadbEndpointConfigSettings
  YAML.mapping(
    name: String
  )
end

class DokkuAppEndpointConfigSettings
  YAML.mapping(
    name: String
  )
end

class DockerImageEndpointConfigSettings
  YAML.mapping(
    tag: { 
      type: String,
      nilable: false,
      default: "latest"
    }
  )
end

class MysqlDumpEndpointConfigSettings
  YAML.mapping(
    path: String
  )
end

class ScriptEndpointConfigSettings
  YAML.mapping(
    path: String
  )
end

