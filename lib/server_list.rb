class ServerList
  def initialize(config)
    @config  = config            || {}
    @servers = config['servers'] || {}
  end

  def all
    @servers
  end

  def [](key)
    @servers[key]
  end

  def []=(key, server)
    @servers[key] = server
  end

  def add(server)
    return if @servers.values.include?(server.to_s)
    key = (@servers.size > 0) ? @servers.keys.last + 1 : 0
    @servers[key] = server.to_s
  end

  def add_all(servers)
    _servers = ServerList.parse_addresses(servers)
    _servers.each { |server| add(server.to_s) }
  end

  def remove(key)
    @servers.delete(key)
  end

  def remove_all(servers)
    _servers = ServerList.parse_keys(servers)
    _servers.each { |server| remove(server.to_i) }
  end

  def save
    File.open('config.yml', 'w') do |f|
      @config['servers'] = @servers
      f.write @config.to_yaml
    end
  end

  #
  # Class Methods
  #

  def self.parse_keys(keys)
    keys.gsub(/[^0-9,]+/, '').split(',')
  end

  def self.parse_addresses(addresses)
    addresses.gsub(/[^0-9,\.]+/, '').split(',')
  end
end
