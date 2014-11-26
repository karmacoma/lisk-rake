require 'crypti_netssh'
require 'singleton'
require 'yaml'

class CryptiKit
  include Singleton

  class << self
    attr_reader :config, :netssh
  end

  @config = YAML.load_file('config.yml')
  @netssh = CryptiNetssh.new(@config['deploy_user'])

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

  def self.app_version
    config['app_version']
  end

  def self.app_url
    config['app_url']
  end

  def self.blockchain_url
    config['blockchain_url']
  end

  def self.configured_servers
    config['servers'] ||= {}
  end

  def self.configured_accounts
    config['accounts'] ||= {}
  end

  def self.sequenced_exec
    { :in => :sequence, :wait => 0 }
  end

  def self.baddies
    @baddies ||= []
  end

  def self.zip_file
    "crypti-linux-#{self.app_version}.zip"
  end

  def self.install_path
    [deploy_path, '/', app_version].join
  end

  def self.apt_conflicts
    ['nodejs', 'nodejs-legacy', 'npm']
  end

  def self.apt_dependencies
    ['build-essential', 'curl', 'python', 'wget', 'unzip']
  end
end
