class ForgingStatus
  def initialize(json)
    @json = json
  end

  def forging_enabled
    [': Forging Enabled: ', @json['forgingEnabled']]
  end

  def to_s
    [forging_enabled].join.to_s
  end
end