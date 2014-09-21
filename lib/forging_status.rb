class ForgingStatus
  def initialize(json)
    @json = json
  end

  def forging_enabled
    [sprintf("%-13s", 'Forging:'), @json['forgingEnabled'], "\n"]
  end

  def to_s
    [forging_enabled].join.to_s
  end
end