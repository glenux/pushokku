
require "yaml"

class DeploymentConfig
  YAML.mapping(
    local: String,
    remote: String,
    type: String,
  )
end
