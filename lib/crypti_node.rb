class CryptiNode
  attr_reader :server

  def initialize(server)
    @server = server
  end

  def key
    CryptiKit.config['servers'].key(@server.to_s)
  end

  def value(k)
    val = CryptiKit.config['accounts'][key]
    val = val.is_a?(Hash) ? val[k.to_s] : nil
    val
  end

  def account
    value('address')
  end

  def public_key
    value('public_key')
  end

  def info
    green("Node[#{key}]: #{@server} (#{account || 'No Account'})")
  end

  def get_passphrase(&block)
    print info + yellow(": Please enter your secret passphrase:\s")
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
