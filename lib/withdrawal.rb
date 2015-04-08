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
      return if withdrawal <= 0.0
      PassphraseCollector.collect(passphrases?) do |passphrases|
        @task.info "Withdrawing #{withdrawal} XCR to: #{@account.address}..."
        json = @api.put '/api/transactions', params(passphrases)
        transaction(json) do |fee, id, amount|
          @task.info green("~> Fee: #{fee}")
          @task.info green("~> Transaction id: #{id}")
          @task.info green("~> Total withdrawn: #{amount}")
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

    def network_fee(amount = nil)
      @network_fee ||= get_network_fee

      unless amount.nil? then
        (amount * (@network_fee / 100 * 10**8))
      else
        @network_fee
      end
    end

    def get_balance
      @task.info 'Checking account balance...'

      json = @api.get '/api/accounts/getBalance', { address: @node.account }
      @second_passphrase = json['secondPassphrase']
      json['balance'].to_bd
    end

    def get_withdrawal
      validate do
        balance = get_balance
        maximum = balance / (1 + (network_fee * 10**8 / 100))

        @task.info "=> Current balance: #{balance.to_xcr} XCR."
        @task.info "=> Maximum withdrawal: #{maximum.to_xcr} XCR."

        begin
          print yellow("Enter withdrawal amount:\s")
          match = STDIN.gets.chomp.match(/[0-9.]+/i)

          if match.is_a?(MatchData)
            match[0].to_f
          else
            raise ArgumentError
          end
        rescue Interrupt
          puts ''
          return 0.0
        rescue ArgumentError
          print red("Invalid withdrawal amount. Please try again...\n")
          retry
        end
      end
    end

    def withdrawal
      @withdrawal ||= get_withdrawal
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
          amount: (withdrawal.to_f * 10**8),
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
        fee    = network_fee(withdrawal).to_xcr
        id     = json['transactionId'].to_i
        amount = withdrawal.to_f
        yield fee, id, amount
      else
        @task.error "=> Transaction failed."
        @task.error "=> Error: #{json['error'] || 'Unknown'}."
      end
    end
  end
end
