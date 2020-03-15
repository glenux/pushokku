
require "yaml"

class RemoteConfig
  YAML.mapping(
    name: String,
    user: String,
    host: String
  )
end

