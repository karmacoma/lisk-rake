module CryptiKit
  class DelegateStatus
    def initialize(json)
      @index = json['index']
      @json  = json['delegate']
      @rate  = json['delegate']['rate'].to_i
    end

    def delegate
      [sprintf("%-19s", "Delegate:"), "(#{index})\s#{username}\s", status, "\s#{@json['address']}", "\n"]
    end

    def productivity
      [sprintf("%-19s", 'Productivity:'), @json['productivity'].to_f, '%', "\n"]
    end

    def rank
      [sprintf("%-19s", 'Rank:'), @rate, "\n"]
    end

    def to_s
      [delegate, productivity, rank].join.to_s
    end

    private

    def index
      blue(@index.to_s)
    end

    def username
      @json['username']
    end

    def status
      (@rate > 0 and @rate <= 101) ? green('[Active]') : yellow('[Standby]')
    end
  end
end
