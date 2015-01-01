require 'bigdecimal'

module CryptiKit
  class Withdrawal
    attr_reader :node, :account

    def initialize(task, &block)
      @task = task
      @api  = Curl.new(@task)
      yield self if block_given?
    end

    def node=(node)
      if node.is_a?(Node) then
        @node = node
      end
    end

    def account=(account)
      if account.is_a?(Account) then
        @account = account
      end
    end

    def withdraw
      return unless loaded?
      return if surplus <= 0.0
      @node.get_passphrases(passphrases?) do |passphrases|
        @task.info "Sending #{surplus.to_xcr} crypti to: #{@account.address}..."
        json = @api.put '/api/transactions', params(passphrases)
        transaction(json) do |fee, id, amount|
          @task.info green("~> Fee: #{fee}")
          @task.info green("~> Transaction id: #{id}")
          @task.info green("~> Total sent: #{amount}")
        end
      end
    end

    private

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
      json = @api.get '/api/blocks/getFee'
      if json['success'] then
        json['fee'].to_bd
      else
        raise 'Failed to get network fee.'
      end
    end

    def network_fee
      @network_fee ||= (
        (surplus * get_network_fee) / 100 * 10**8
      ).round(8)
    end

    def get_surplus
      validate do
        @task.info 'Checking for surplus coinage...'

        json = @api.get '/api/accounts/getBalance', { address: @node.account }
        @second_passphrase = json['secondPassphrase']

        @surplus = json['unconfirmedBalance'].to_bd - 1000
        @surplus = (@surplus - network_fee) > 0.01 ? @surplus : 0.0

        if @surplus > 0 then
          @task.info "=> Available: #{@surplus.to_xcr} crypti."
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
      args << ['secondary', 'secondSecret'] if @second_passphrase
      args
    end

    def params(passphrases)
      if passphrases.is_a?(Hash) then
        passphrases.merge(
          amount: (amount.to_f * 10**8),
          recipientId: @account.address,
          publicKey: @node.public_key
        )
      else
        {}
      end
    end

    def loaded?
      NodeInspector.loaded?(@task)
    end

    def transaction(json, &block)
      if json['success'] then
        fee    = network_fee.to_xcr
        id     = json['transactionId'].to_i
        amount = surplus.to_xcr
        yield fee, id, amount
      else
        @task.error "=> Transaction failed."
        @task.error "=> Error: #{json['error']}."
      end
    end
  end
end
