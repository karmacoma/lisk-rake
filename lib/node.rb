module CryptiKit
  class Node
    attr_reader :server

    def initialize(server)
      @server = server
    end

    def key
      Core.configured_servers.key(@server.to_s)
    end

    def accounts
      Core.configured_accounts[key] || []
    end

    def info
      green("Node[#{key}]: #{@server}\s") +\
       blue("With #{accounts.size} Delegate(s)")
    end
  end
end
