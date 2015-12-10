module CryptiKit
  class ConfigStatus
    def initialize(json)
      @json = json
    end

    def version
      [sprintf("%-19s", 'Version:'), outdated?, "\n"]
    end

    def outdated?
      @json['outdated'] ? Color.red(@json['version']) : Color.green(@json['version'])
    end

    def to_s
      [version].join.to_s
    end
  end
end
