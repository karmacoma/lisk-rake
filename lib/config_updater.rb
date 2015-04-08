require 'stringio'

module CryptiKit
  class ConfigUpdater
    def initialize(task, config)
      @task   = task
      @config = config
    end

    def paths
      @paths ||= {
        config: Core.install_path + '/config.json',
        backup: Core.install_path + '/config.bak'
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

    def self.update(task, config)
      self.new(task, config).update
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
