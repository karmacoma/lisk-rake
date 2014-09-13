require 'yaml'

class CryptiKit
  def initialize(config)
    @config = config
    configure_sshkit
  end

  def deploy_user
    @config['deploy_user']
  end

  def deploy_path
    @config['deploy_path']
  end

  def app_version
    @config['app_version']
  end

  def app_url
    @config['app_url']
  end

  def blockchain_url
    @config['blockchain_url']
  end

  def servers
    servers = @config['servers']
    servers.is_a?(Hash) ? servers.values : []
  end

  def zip_file
    "crypti-linux-#{self.app_version}.zip"
  end

  def install_path
    [self.deploy_path, '/', self.app_version].join
  end

  def apt_dependencies
    ['wget', 'unzip', 'nodejs']
  end

  def npm_dependencies
    ['forever']
  end

  private

  def configure_sshkit
    SSHKit::Backend::Netssh.configure do |ssh|
      ssh.ssh_options = {
        user: self.deploy_user,
        auth_methods: ['publickey']
      }
    end
  end
end
