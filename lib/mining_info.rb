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

  def last_forged
    array = [sprintf("%-13s", 'Last Forged:')]
    if @json['blocks'] and last = @json['blocks'].first then
      array.concat(['Block -> ', last['id'], ' Amount -> ', to_f(@json['totalFee']), "\n"])
    else
      array.concat(['None', "\n"])
    end
    array
  end

  def to_s
    [forging, forged, last_forged].join.to_s
  end
end