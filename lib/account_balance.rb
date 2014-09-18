class AccountBalance
  def initialize(json)
    @json = json
  end

  def balance
    [sprintf("%-13s", 'Balance:'), to_f(@json['balance'])]
  end

  def unconfirmed_balance
    [sprintf("%-13s", 'Unconfirmed:'), to_f(@json['unconfirmedBalance'])]
  end

  def effective_balance
    [sprintf("%-13s", 'Effective:'), to_f(@json['effectiveBalance'])]
  end

  def to_f(balance)
    (balance.to_f / 10**8).to_f
  end

  def to_s
    [balance, "\n", unconfirmed_balance, "\n", effective_balance, "\n", "-" * 80].join.to_s
  end
end