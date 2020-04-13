
require "yaml"
require "./config/*"

class Config
  YAML.mapping(
    version: String,
    hosts: Array(HostConfig),
    endpoints: Array(EndpointConfig),
    filters: Array(FilterConfig),
    deployments: Array(DeploymentConfig)
  )

  alias FindableConfig = 
    Array(HostConfig) | 
    Array(EndpointConfig) | 
    Array(FilterConfig) | 
    Array(DeploymentConfig)

  class MissingItemError < Exception 
  end

  class MultipleItemsError < Exception
  end

  def find(list : FindableConfig, name : String, str : String)
    matches = list.select { |item| item.name == name }
    if matches.size > 1 
      raise MultipleItemsError.new "Multiple #{str} have the name #{str}"
    end
    if matches.size < 1
      raise MissingItemError.new "No #{str} found for name #{name}"
    end
    return matches.first
  end

  def find_host(name : String) : HostConfig
    find(self.hosts, name, "hosts")
  end

  def find_endpoint(name : String) : EndpointConfig
    find(self.endpoints, name, "endpoints")
  end

  def find_filter(name : String) : FilterConfig
    find(self.filters, name, "filters")
  end

  def find_deployment(name : String) : DeploymentConfig
    find(self.deployments, name, "deployments")
  end
end
