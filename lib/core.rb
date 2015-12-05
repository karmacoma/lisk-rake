require 'netssh'
require 'singleton'
require 'yaml'

module CryptiKit
  class Core
    include Singleton

    class << self
      attr_reader :config, :netssh
    end

    @config = YAML.load_file('config.yml')
    @netssh = Netssh.new(@config['deploy_user'])

    def self.deploy_user
      config['deploy_user']
    end

    def self.deploy_user_at_host(host)
      "#{deploy_user}@#{host}"
    end

    def self.deploy_key
      '~/.ssh/id_rsa.pub'
    end

    def self.deploy_path
      config['deploy_path']
    end

    def self.install_path
      [deploy_path, '/install'].join
    end

    def self.download_url
      config['download_url']
    end

    def self.environment
      config['environment']
    end

    def self.live?
      environment == 'live'
    end

    def self.test?
      environment == 'test'
    end

    def self.reference_node
      config['reference_node']
    end

    def self.timestamp(offset)
      genesis = config['genesis'].to_i
      offset  = offset.to_i
      if (genesis > 0 and offset > 0) then
        genesis + offset
      end
    end

    def self.app_port
      (test?) ? 7040 : 8040
    end

    def self.configured_servers
      config['servers'] ||= {}
    end

    def self.configured_accounts
      config['accounts'] ||= {}
    end

    def self.top_accounts
      (config['top_accounts'].to_s == 'true')
    end

    def self.baddies
      @baddies ||= []
    end
  end
end
