class CryptiNode
  def initialize(config, server)
    @config = config
    @server = server
  end

  def key
    @config['servers'].key(@server.to_s)
  end

  def value(k)
    val = @config['accounts'][key]
    val = val.is_a?(Hash) ? val[k.to_s] : nil
    val
  end

  def account
    value('address')
  end

  def public_key
    value('publickey')
  end

  def info
    "Node[#{key}]: #{@server} (#{account || 'No Account'})"
  end

  def get_passphrase(&block)
    print info + ": Please enter your secret passphrase:\s"
    passphrase = STDIN.noecho(&:gets)
    passphrase = { :secret => passphrase.chomp }
    print "\n"
    if block_given? then
      block.call(passphrase)
    else
      passphrase
    end
  end
end