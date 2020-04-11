
require "yaml"
require "./host_settings"

class LocalHostConfig
  YAML.mapping(
    name: String,
    localhost: Hash(String, YAML::Any)
  )
end


class SshHostConfig
  YAML.mapping(
    name: String,
    ssh: SshHostConfigSettings
  )
end

alias HostConfig = 
  LocalHostConfig |
  SshHostConfig
