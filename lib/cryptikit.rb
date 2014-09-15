require 'yaml'
require 'json'

class CryptiKit
  def initialize(config)
    @config = config
    configure_sshkit
  end

  def deploy_user
    @config['deploy_user']
  end

  def deploy_key
    '~/.ssh/id_rsa.pub'
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

  def servers(selected = nil)
    if @config['servers'].is_a?(Hash) then
      select_servers(@config['servers'].values, selected)
    else
      []
    end
  end

  def zip_file
    "crypti-linux-#{self.app_version}.zip"
  end

  def install_path
    [self.deploy_path, '/', self.app_version].join
  end

  def apt_dependencies
    ['build-essential', 'wget', 'unzip', 'nodejs']
  end

  def npm_dependencies
    ['forever']
  end

  def get_passphrase(server)
    print "Node: #{server}: Please enter your secret passphrase:\s"
    passphrase = STDIN.noecho(&:gets)
    passphrase = { :secret => passphrase.chomp }
    print "\n"
    passphrase.to_json
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

  def select_servers(servers, selected)
    if selected.nil? or selected.size <= 0 then
      return servers
    else
      _selected = selected.gsub(/[^0-9,]+/, '').split(',')
      _selected.collect { |s| servers[s.to_i] }.compact
    end
  end
end
