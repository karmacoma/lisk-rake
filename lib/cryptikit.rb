class CryptiKit
  def initialize(config)
    @config = YAML.load_file(config)
    @config['servers'] ||= {}
    @netssh = CryptiNetssh.new(@config['deploy_user'])
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

  def server_delay
    1
  end

  def servers(selected = nil)
    if selected.nil? or selected.size <= 0 then
      return @config['servers'].values
    else
      _selected = selected.gsub(/[^0-9,]+/, '').split(',')
      _selected.collect { |s| @config['servers'].values[s.to_i] }.compact
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
end
