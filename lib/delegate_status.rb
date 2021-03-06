module LiskRake
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
      Color.light_blue(@index.to_s)
    end

    def username
      Color.light_blue(@json['username'])
    end

    def status
      (@rate > 0 and @rate <= 101) ? Color.green('[Active]') : Color.yellow('[Standby]')
    end
  end
end
