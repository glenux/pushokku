
require "yaml"

class DokkuRemoteConfigSettings
  YAML.mapping(
    user: String,
    host: String
  )
end

class DokkuRemoteConfig
  YAML.mapping(
    name: String,
    dokku: DokkuRemoteConfigSettings
  )
end

alias RemoteConfig =
  DokkuRemoteConfig
