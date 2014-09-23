class MiningInfo
  def initialize(json)
    @json = json
  end

  def to_f(balance)
    (balance.to_f / 10**8).to_f
  end

  def forging
    [sprintf("%-13s", 'Forging:'), @json['forging'], "\n"]
  end

  def forged
    [sprintf("%-13s", 'Forged:'), to_f(@json['totalForged']), "\n"]
  end

  def to_s
    [forging, forged].join.to_s
  end
end