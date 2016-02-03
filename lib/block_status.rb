module LiskRake
  class BlockStatus
    def initialize(json)
      @json = json
    end

    def height
      [sprintf("%-19s", 'Height:'), @json['height'].to_i, "\n"]
    end

    def to_s
      [height].join.to_s
    end
  end
end
