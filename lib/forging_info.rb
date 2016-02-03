module LiskRake
  class ForgingInfo
    def initialize(json, cache)
      @json  = json
      @cache = cache || {}
    end

    def last_forged
      array = [sprintf("%-19s", 'Last Forged:')]
      if @json['blocks'] and last = @json['blocks'].first then
        timestamp = Core.timestamp(last['timestamp'])
        array.concat([last['totalForged'].to_lisk, Color.light_blue(' @ '), last['height'], Color.light_blue(' -> '), Time.at(timestamp), "\n"])
      else
        array.concat(['None', "\n"])
      end
      array
    end

    def forged
      change = BalanceChange.new(@json['forged'], @cache['forged'])
      [sprintf("%-19s", 'Forged:'), @json['forged'].to_lisk, change.to_s, "\n"]
    end

    def to_s
      [last_forged, forged].join.to_s
    end
  end
end
