require 'stringio'

module CryptiKit
  class ConfigUpdater
    def initialize(task, node, config)
      @task   = task
      @node   = node
      @config = config
    end

    def paths
      @paths ||= {
        config: @node.lisk_path + '/config.json',
        backup: @node.lisk_path + '/config.bak'
      }
    end

    def update
      @task.info 'Updating configuration...'
      @task.capture 'cp', '-f', paths[:config], paths[:backup]
      @task.upload! StringIO.new(to_json), paths[:config]
      @task.info '=> Done.'
    rescue
      @task.capture 'cp', '-f', paths[:backup], paths[:config]
      @task.error '=> Failed.'
    ensure
      @task.capture 'rm', '-f', paths[:backup]
    end

    def self.update(task, node, config)
      self.new(task, node, config).update
    end

    private

    def to_h
      @config.delete('success')
      @config.delete('outdated')
      @config
    end

    def to_json
      JSON.pretty_generate(to_h)
    end
  end
end
