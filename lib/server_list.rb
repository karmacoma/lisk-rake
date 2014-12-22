require 'list'

module CryptiKit
  class ServerList < List
    @key          = 'servers'
    @key_regexp   = List.key_regexp
    @value_regexp = /[^0-9,\.]+/
    @reindex      = true

    def before_save
      Core.config['accounts'].keys.each do |key|
        Core.config['accounts'].delete(key) if !@items[key]
      end
    end

    def forget_all(items)
      known_hosts = KnownHosts.new(self)
      known_hosts.forget(items)
    end
  end
end
