class AccountBalance
  def initialize(json)
    @json = json
  end

  def to_f(balance)
    (balance.to_f / 10**8).to_f
  end

  def balance
    [sprintf("%-19s", 'Balance:'), to_f(@json['balance']), "\n"]
  end

  def unconfirmed_balance
    [sprintf("%-19s", 'Unconfirmed:'), to_f(@json['unconfirmedBalance']), "\n"]
  end

  def effective_balance
    [sprintf("%-19s", 'Effective:'), to_f(@json['effectiveBalance']), "\n"]
  end

  def to_s
    [balance, unconfirmed_balance, effective_balance].join.to_s
  end
end
