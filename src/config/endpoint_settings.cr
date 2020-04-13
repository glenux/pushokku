
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
    name: String,
    tag: { 
      type: String,
      nilable: false,
      default: "latest"
    }
  )

  def initialize(@name : String, @tag : String)
  end

  def to_s 
    "#{name}:#{tag}"
  end
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

