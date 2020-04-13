
require "yaml"
require "./host_settings"

class LocalHostConfig
  YAML.mapping(
    name: String,
    localhost: Hash(String, YAML::Any)
  )

  def to_s
    "LocalHost[#{name}]"
  end
end


class SshHostConfig
  YAML.mapping(
    name: String,
    ssh: SshHostConfigSettings
  )
  def to_s
    "SshHost[#{name}]"
  end
end

alias HostConfig = 
  LocalHostConfig |
  SshHostConfig
