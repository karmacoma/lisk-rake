module CryptiKit
  class LoadingStatus
    def initialize(json)
      @json = json
    end

    def loaded
      [sprintf("%-19s", 'Loaded:'), @json['loaded'] == true, "\n"]
    end

    def height
      [sprintf("%-19s", 'Height:'), @json['height'].to_i, "\n"]
    end

    def blocks_count
      [sprintf("%-19s", 'Blocks:'), @json['blocksCount'].to_i, "\n"]
    end

    def to_s
      [loaded, height, blocks_count].join.to_s
    end
  end
end
