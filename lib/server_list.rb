require 'list'

module CryptiKit
  class ServerList < List
    @key          = 'servers'
    @key_regexp   = List.key_regexp
    @value_regexp = /[^0-9,\.]+/
    @reindex      = true

    def before_save
      Core.configured_accounts.keys.each do |key|
        Core.configured_accounts.delete(key) if !@items[key]
      end
    end

    def forget_all(items)
      known_hosts = KnownHosts.new(self)
      known_hosts.forget(items)
    end

    def self.parse_values(values)
      super(values).collect do |value|
        { 'hostname'    => value,
          'user'        => Core.deploy_user,
          'port'        => Core.deploy_port,
          'deploy_path' => Core.deploy_path,
          'crypti_path' => Core.crypti_path }
      end
    end
  end
end
