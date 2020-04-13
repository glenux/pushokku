
require "colorize"

class Deployment
  def self.apply_run!(
    config : Config, 
    src : ScriptEndpointConfig, 
    dest : DokkuAppEndpointConfig 
  )
    dokku_app = dest.name 
  #  image_meta = image_tag(@local.docker_image, dokku_app)
  #  image_push(@remote.host, image_meta["tag_name_version"])
  #  image_deploy(@remote.host, image_meta["app"], image_meta["version"])
  end
end
