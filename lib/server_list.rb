require 'list'

module LiskRake
  class ServerList < List
    @key          = 'servers'
    @key_regexp   = List.key_regexp
    @value_regexp = /[\s]+/
    @reindex      = true

    def include?(item)
      if item.is_a?(Hash) then
        @items.any? { |k,v| v['hostname'] == item['hostname'] }
      else
        false
      end
    end

    def forget_all(keys)
      return unless keys.is_a?(Array)
      known_hosts = [ENV['HOME'], '/.ssh/known_hosts'].join
      return unless File.exists?(known_hosts)
      keys.each do |key|
        hostname = Core.servers[key]['hostname'] rescue nil
        system "ssh-keygen -R #{hostname} -f #{known_hosts} > /dev/null 2>&1" if hostname
      end
    end

    def self.parse_values(values)
      super(values).collect do |value|
        { 'hostname'    => value,
          'user'        => Core.deploy_user,
          'port'        => Core.deploy_port,
          'deploy_path' => Core.deploy_path,
          'lisk_path'   => Core.lisk_path,
          'accounts'    => [] }
      end
    end
  end
end
