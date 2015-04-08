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
      Core.configured_accounts[key]
    end

    def account
      accounts[0]['address'] rescue nil
    end

    def public_key
      accounts[0]['public_key'] rescue nil
    end

    def info
      green("Node[#{key}]: #{@server} (#{account || 'No Account'})")
    end

    def passphrases
      @passphrases ||= {}
    end

    def get_passphrase(args = ['primary', 'secret'], &block)
      print info + yellow(": Please enter your #{args.first} passphrase:\s")
      passphrases.merge!(args.last.to_sym => Passphrase.gets) and puts
      block_given? ? block.call(passphrases) : passphrases
    end

    def get_passphrases(args, &block)
      args.each { |arg| get_passphrase(arg) }
      block_given? ? block.call(passphrases) : passphrases
    end
  end
end
