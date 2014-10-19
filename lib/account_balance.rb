class AccountBalance
  def initialize(json)
    @json = json
  end

  def balance
    [sprintf("%-19s", 'Balance:'), @json['balance'].to_xcr, "\n"]
  end

  def unconfirmed_balance
    [sprintf("%-19s", 'Unconfirmed:'), @json['unconfirmedBalance'].to_xcr, "\n"]
  end

  def effective_balance
    [sprintf("%-19s", 'Effective:'), @json['effectiveBalance'].to_xcr, "\n"]
  end

  def to_s
    [balance, unconfirmed_balance, effective_balance].join.to_s
  end
end
