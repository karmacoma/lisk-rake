module CryptiKit
  class ConfigInspector
    def initialize(task)
      @task = task
    end

    def capture
      @task.info 'Getting configuration...'
      conf = @task.capture 'cat', "#{Core.install_path}/config.json"
      json = JSON.parse(conf) rescue {}
      if !json.empty? then
        @task.info '=> Done.'
        json['success'] = true
      else
        @task.warn '=> Configuration not available.'
        json['success'] = false
      end
      json
    end

    def data
      @data ||= capture
    end

    def inspect
      data['outdated'] = outdated?
      data
    end

    def self.inspect(task)
      self.new(task).inspect
    end

    private

    def outdated?
      return false unless ReferenceNode.version
      return false if ReferenceNode.version == @data['version']
      return [@data['version'], ReferenceNode.version].sort.first == @data['version']
    end
  end
end
