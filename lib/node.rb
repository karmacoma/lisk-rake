module CryptiKit
  class Node
    attr_reader :server

    def initialize(server)
      if server.kind_of?(SSHKit::Host) then
        @server = server
      else
        @server = SSHKit::Host.new(server)
      end
    end

    def key
      @key ||= Core.servers.find_index do |s|
        s[1]['hostname'] == hostname
      end.tap do |k|
        return (k.nil?) ? 0 : k + 1
      end
    end

    def hostname
      @server.hostname
    end

    def deploy_path
      @server.deploy_path
    end

    def crypti_path
      [@server.deploy_path, @server.crypti_path].join
    end

    def accounts
      if Core.servers[key].is_a?(Hash) then
        Core.servers[key]['accounts'] || []
      else
        []
      end
    end

    def info
      Color.green("Node[#{key}]: #{hostname}\s") +\
       Color.light_blue("With #{accounts.size} Delegate(s)")
    end
  end
end
