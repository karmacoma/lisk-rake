class LoadingStatus
  def initialize(json)
    @json = json
  end

  def loaded
    [sprintf("%-13s", 'Loaded:'), @json['loaded'], "\n"]
  end

  def height
    [sprintf("%-13s", 'Height:'), @json['height'], "\n"]
  end

  def blocks_count
    [sprintf("%-13s", 'Blocks:'), @json['blocksCount'], "\n"]
  end

  def to_s
    [loaded, height, blocks_count].join.to_s
  end
end