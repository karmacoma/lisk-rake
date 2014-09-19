class ForgingStatus
  def initialize(json)
    @json = json
  end

  def forging_enabled
    [sprintf("%-13s", 'Forging:'), @json['forgingEnabled']]
  end

  def to_s
    [forging_enabled, "\n"].join.to_s
  end
end