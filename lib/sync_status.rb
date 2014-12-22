module CryptiKit
  class SyncStatus
    def initialize(json)
      @json = json
    end

    def syncing
      [sprintf("%-19s", 'Syncing:'), @json['sync'] == true, "\n"]
    end

    def to_s
      [syncing].join.to_s
    end
  end
end
