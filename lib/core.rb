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

    def self.deploy_port
      config['deploy_port']
    end

    def self.ssh_options(server)
      "#{server.user}@#{server.hostname} -p #{server.port}"
    end

    def self.deploy_key
      config['deploy_key']
    end

    def self.deploy_path
      config['deploy_path']
    end

    def self.crypti_path
      config['crypti_path']
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

    def self.servers
      config['servers'] ||= {}
    end

    def self.top_accounts
      (config['top_accounts'].to_s == 'true')
    end

    def self.baddies
      @baddies ||= []
    end

    def self.task(&block)
      yield
    rescue Exception => exception
      puts Color.red(exception)
      raise 'Task failed.'
    end
  end
end
