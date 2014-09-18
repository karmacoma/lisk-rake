class LoadingStatus
  def initialize(json)
    @json = json
  end

  def loaded
    [sprintf("%-13s", 'Loaded:'), @json['loaded']]
  end

  def height
    [sprintf("%-13s", 'Height:'), @json['height']]
  end

  def blocks_count
    [sprintf("%-13s", 'Blocks:'), @json['blocksCount']]
  end

  def to_s
    [loaded, "\n", height, "\n", blocks_count, "\n", "-" * 80].join.to_s
  end
end