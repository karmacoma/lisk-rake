class CryptiKit
  attr_reader :config

  def initialize(config)
    @config = YAML.load_file(config)
    @config['servers']  ||= {}
    @config['accounts'] ||= {}
    @netssh = CryptiNetssh.new(@config['deploy_user'])
  end

  def deploy_user
    @config['deploy_user']
  end

  def deploy_user_at_host(host)
    "#{deploy_user}@#{host}"
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
    if selected.nil? or selected.size <= 0 then
      return @config['servers'].values
    else
      _selected = ServerList.parse_keys(selected)
      _selected.collect { |s| @config['servers'].values[s.to_i] }.compact
    end
  end

  def sequenced_exec
    { :in => :sequence, :wait => 0 }
  end

  def zip_file
    "crypti-linux-#{self.app_version}.zip"
  end

  def install_path
    [deploy_path, '/', app_version].join
  end

  def apt_dependencies
    ['build-essential', 'wget', 'unzip', 'nodejs']
  end

  def npm_dependencies
    ['forever']
  end
end
