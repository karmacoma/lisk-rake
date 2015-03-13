module CryptiKit
  class ConfigInspector
    def initialize(json)
      @json = json
    end

    def inspect
      @json['outdated'] = outdated?
      @json
    end

    def self.inspect(json)
      self.new(json).inspect
    end

    private

    def outdated?
      return false unless ReferenceNode.version
      return false if ReferenceNode.version == @json['version']
      return [@json['version'], ReferenceNode.version].sort.first == @json['version']
    end
  end
end
