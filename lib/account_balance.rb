module LiskRake
  class AccountBalance
    def initialize(json, cache)
      @json  = json
      @cache = cache || {}
    end

    def balance
      change = BalanceChange.new(@json['balance'], @cache['balance'])
      [sprintf("%-19s", 'Balance:'), @json['balance'].to_xcr, change.to_s, "\n"]
    end

    def unconfirmed_balance
      change = BalanceChange.new(@json['unconfirmedBalance'], @cache['unconfirmedBalance'])
      [sprintf("%-19s", 'Unconfirmed:'), @json['unconfirmedBalance'].to_xcr, change.to_s, "\n"]
    end

    def to_s
      [balance, unconfirmed_balance].join.to_s
    end
  end
end
