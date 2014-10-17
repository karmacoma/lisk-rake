class MiningInfo
  def initialize(json)
    @json = json
  end

  def forging
    [sprintf("%-19s", 'Forging:'), @json['forging'], "\n"]
  end

  def last_forged
    array = [sprintf("%-19s", 'Last Forged:')]
    if @json['blocks'] and last = @json['blocks'].first then
      array.concat(['Block -> ', last['id'], ' Amount -> ', AccountBalance.to_f(@json['totalFee']), "\n"])
    else
      array.concat(['None', "\n"])
    end
    array
  end

  def forged
    [sprintf("%-19s", 'Forged:'), AccountBalance.to_f(@json['totalForged']), "\n"]
  end

  def to_s
    [forging, last_forged, forged].join.to_s
  end
end
