class CryptiWithdrawal
  attr_reader :node, :account

  def initialize(task, &block)
    @task = task
    @api  = CryptiApi.new(@task)
    yield self
  end

  def node=(node)
    if node.is_a?(CryptiNode) then
      @node = node
    end
  end

  def account=(account)
    if account.is_a?(CryptiAccount) then
      @account = account
    end
  end

  def validate(&block)
    case
    when !@node then
      raise 'Missing crypti node.'
    when !@node.account then
      raise 'Crypti node does not have an account.'
    when !@account then
      raise 'Missing withdrawal account.'
    when !@account.address then
      raise 'Missing withdrawal address.'
    when @node.account == @account.address then
      raise 'Can not withdraw from/to the same account.'
    else
      yield
    end
  end

  def get_network_fee
    json = @api.get '/api/getFee'
    if json['success'] then
      json['fee'].to_f
    else
      raise 'Failed to get network fee.'
    end
  end

  def network_fee
    @network_fee ||= (surplus * get_network_fee) / 100
  end

  def get_surplus
    validate do
      @task.info 'Checking for surplus coinage...'

      json = @api.get '/api/getBalance', { address: @node.account }
      @second_passphrase = json['secondPassphrase']

      @surplus = (AccountBalance.to_f(json['unconfirmedBalance']) - 1000)
      @surplus = (@surplus - network_fee) > 0.01 ? @surplus.round(8) : 0.0

      if @surplus > 0 then
        @task.info "=> Available: #{@surplus} crypti."
      else
        @task.warn '=> None available.'
      end
      @surplus
    end
  end

  def surplus
    @surplus ||= get_surplus
  end

  def amount
    @amount ||= (surplus - network_fee)
  end

  def passphrases?
    args =  Array.new
    args << ['primary', 'secret']
    args << ['secondary', 'secondPhrase'] if @second_passphrase
    args
  end

  def params(passphrases)
    if passphrases.is_a?(Hash) then
      passphrases.merge(amount: amount.round(8), recipient: @account.address, accountAddress: @node.account)
    else
      {}
    end
  end

  def withdraw
    return if surplus <= 0.0
    @node.get_passphrases(passphrases?) do |passphrases|
      @task.info "Sending #{surplus} crypti to: #{@account.address}..."
      json = @api.post '/api/sendFunds', params(passphrases)
      if json['success'] then
        fee  = AccountBalance.to_f(json['fee'])
        sent = (surplus + fee).round(8)
        @task.info green("~> Fee: #{fee}")
        @task.info green("~> Transaction id: #{json['transactionId']}")
        @task.info green("~> Total sent: #{sent}")
      else
        @task.error "=> Transaction failed."
        @task.error "=> Error: #{json['error']}."
      end
    end
  end
end
