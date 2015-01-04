module CryptiKit
  class SyncStatus
    def initialize(json)
      @json = json
    end

    def syncing
      [sprintf("%-19s", 'Syncing:'), @json['sync'] == true, "\n"]
    end

    def height
      if @json['sync'] then
        [sprintf("%-19s", 'Height:'), @json['height'].to_i, ' / ', @json['blocks'].to_i, "\n"]
      end
    end

    def to_s
      [syncing, height].join.to_s
    end
  end
end
