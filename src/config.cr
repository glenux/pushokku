
require "yaml"
require "./config/*.cr"

class Config
  YAML.mapping(
    version: String,
    hosts: Array(HostConfig),
    endpoints: Array(EndpointConfig),
    filters: Array(FilterConfig),
    deployments: Array(DeploymentConfig)
  )
end
