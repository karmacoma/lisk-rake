class MiningInfo
  def initialize(json, cache)
    @json  = json
    @cache = cache || {}
  end

  def last_forged
    array = [sprintf("%-19s", 'Last Forged:')]
    if @json['blocks'] and last = @json['blocks'].first then
      array.concat(['Block -> ', last['id'], ' Amount -> ', last['totalFee'].to_xcr, "\n"])
    else
      array.concat(['None', "\n"])
    end
    array
  end

  def forged
    change = BalanceChange.new(@json['totalForged'], @cache['totalForged'])
    [sprintf("%-19s", 'Forged:'), @json['totalForged'].to_xcr, change.to_s, "\n"]
  end

  def to_s
    [last_forged, forged].join.to_s
  end
end
