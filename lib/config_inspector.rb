module CryptiKit
  class ConfigInspector
    def initialize(task, node)
      @task = task
      @node = node
    end

    def capture
      @task.info 'Getting configuration...'
      conf = @task.capture 'cat', "#{@node.lisk_path}/config.json"
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

    def self.inspect(task, node)
      self.new(task, node).inspect
    end

    private

    def outdated?
      return false unless ReferenceNode.version
      return false if ReferenceNode.version == @data['version']
      return [@data['version'], ReferenceNode.version].sort.first == @data['version']
    end
  end
end
