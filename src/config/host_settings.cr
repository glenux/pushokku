
require "yaml"

class SshHostConfigSettings
  YAML.mapping(
    user: String,
    host: String
  )
end
