
require "yaml"

class SshHostConfigSettings
  YAML.mapping(
    user: String,
    host: String
  )

  def to_s 
    "#{user}@#{host}"
  end
end
