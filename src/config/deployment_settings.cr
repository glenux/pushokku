
require "yaml"

class TransferDeploymentConfigSettings
  YAML.mapping(
    src: String,
    dest: String,
    filters: Array(String)?
  )
end

class RunDeploymentConfigSettings
  YAML.mapping(
    src: String,
    dest: String,
  )
end
