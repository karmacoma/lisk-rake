require 'sshkit'
require 'sshkit/dsl'

module CryptiKit
  class CryptiNetssh
    attr_accessor :config

    def initialize(deploy_user)
      @config = SSHKit::Backend::Netssh.configure do |ssh|
        ssh.ssh_options = {
          user: deploy_user,
          auth_methods: %w(publickey password)
        }
      end
    end
  end
end
