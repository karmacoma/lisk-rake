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

    def user
      @server.user
    end

    def hostname
      @server.hostname || '0.0.0.0'
    end

    def deploy_path(task = nil)
      if @deploy_path then
        @deploy_path
      elsif task and @server.deploy_path =~ /[$]+/ then
        @deploy_path ||= task.capture %(echo "#{@server.deploy_path}")
      else
        @deploy_path ||= @server.deploy_path
      end
    end

    def lisk_path
      [deploy_path, @server.lisk_path].join
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
