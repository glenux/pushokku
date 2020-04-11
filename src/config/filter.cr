
require "yaml"
require "./filter_settings"


class DualFilterConfig
  YAML.mapping(
    name: String,
    dual: DualFilterConfigSettings
  )
end

class MonoFilterConfig
  YAML.mapping(
    name: String,
    cmd: String
  )
end

alias FilterConfig = 
  MonoFilterConfig |
  DualFilterConfig
