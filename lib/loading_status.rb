module LiskRake
  class LoadingStatus
    def initialize(json)
      @json = json
    end

    def loaded
      [sprintf("%-19s", 'Loaded:'), @json['loaded'] == true, "\n"]
    end

    def height
      unless @json['loaded'] then
        [sprintf("%-19s", 'Height:'), @json['now'].to_i, ' / ', @json['blocksCount'].to_i, "\n"]
      end
    end

    def to_s
      [loaded, height].join.to_s
    end
  end
end
