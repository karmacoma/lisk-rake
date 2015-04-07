module CryptiKit
  class DelegateStatus
    def initialize(json)
      @json = json['delegate']
      @rate = @json['rate'].to_i
    end

    def delegate
      [sprintf("%-19s", 'Delegate:'), @json['username'], "\s", status, "\n"]
    end

    def status
      (@rate > 0 and @rate <= 101) ? green('[Active]') : yellow('[Standby]')
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
  end
end
