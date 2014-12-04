class ForgingStatus
  def initialize(json)
    @json = json
  end

  def forging
    [sprintf("%-19s", 'Forging:'), @json['forgingEnabled'] == true, "\n"]
  end

  def to_s
    [forging].join.to_s
  end
end
