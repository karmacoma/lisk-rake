require 'sshkit'
require 'sshkit/dsl'

module CryptiKit
  class Netssh
    attr_accessor :config

    def initialize(deploy_user)
      @config = SSHKit::Backend::Netssh.configure do |ssh|
        ssh.ssh_options = {
          user: deploy_user,
          auth_methods: %w(publickey)
        }
      end
    end

    def self.pty(&block)
      SSHKit::Backend::Netssh.config.pty = true
      yield
      SSHKit::Backend::Netssh.config.pty = false
    end
  end
end
