
require "yaml"

enum LocalType
  DOCKER_IMAGE = 1
  MYSQL_DUMP = 2

  def to_yaml(io)
    to_s(io)
  end
end

class LocalConfig
  YAML.mapping(
    name: String,
    type: LocalType, # enum ?
    docker_image: String | Nil,
    path: String | Nil
  )
end

