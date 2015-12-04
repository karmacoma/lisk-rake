module CryptiKit
  class ProcessStatus
    def initialize(json)
      @json = json
    end

    def uptime
      [sprintf("%-19s", 'Uptime:'), @json['etime'] || 'N/A', "\n"]
    end

    def usage
      [sprintf("%-19s", 'Usage:'), 'CPU: ', @json['cpu'].to_f, '% ', '| Memory: ', @json['mem'].to_f, '%', "\n"]
    end

    def to_s
      [usage, uptime].join.to_s
    end
  end
end
