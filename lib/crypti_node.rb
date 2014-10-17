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

  def passphrases
    @passphrases ||= {}
  end

  def get_passphrase(args = ['primary', 'secret'], &block)
    print info + yellow(": Please enter your #{args.first} passphrase:\s")
    passphrases.merge!(args.last.to_sym => STDIN.noecho(&:gets).chomp) and puts
    block_given? ? block.call(passphrases) : passphrases
  end

  def get_passphrases(args, &block)
    args.each { |arg| get_passphrase(arg) }
    block_given? ? block.call(passphrases) : passphrases
  end
end
