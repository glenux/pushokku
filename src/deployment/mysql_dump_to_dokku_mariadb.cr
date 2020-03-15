
class MysqlDumpToDokkuMariadb
  def self.handler 
    "mysql_dump_to_dokku_mariadb"
  end

  def initialize(@local : LocalConfig, @remote : RemoteConfig, @deployment : DeploymentConfig)
  end

  def run
  end
end

