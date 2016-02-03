module LiskRake
  class PassphraseManager
    def initialize(task, node)
      @task = task
      @node = node
    end

    def add(passphrase)
      @task.info 'Adding passphrase to remote config...'
      add?(passphrase) do |passphrase|
        update_config do |config|
          unless config['forging']['secret'].include?(passphrase) then
            config['forging']['secret'].push(passphrase)
          end
        end
      end
    end

    def remove(passphrase)
      @task.info 'Removing passphrase from remote config...'
      remove?(passphrase) do |passphrase|
        update_config do |config|
          if index = config['forging']['secret'].index(passphrase) then
            config['forging']['secret'].delete_at(index)
          end
        end
      end
    end

    private

    def add?(passphrase, &block)
      if passphrase.is_a?(Hash) then
        puts Color.yellow("Add passphrase to remote config?")
        Core.gets.match(/y|yes/i)
        yield Passphrase.to_s(passphrase[:secret])
      else
        @task.warn '=> Skipped.'
      end
    end

    def remove?(passphrase, &block)
      if passphrase.is_a?(Hash) then
        yield Passphrase.to_s(passphrase[:secret])
      else
        @task.warn '=> Skipped.'
      end
    end

    def inspect_config
      config = ConfigInspector.inspect(@task, @node)
      config['forging'] ||= {}

      secret = config['forging']['secret']
      if secret.nil? then
        config['forging']['secret'] = ''
      elsif secret.is_a?(String) and secret.size > 0 then
        config['forging']['secret'] = [secret]
      elsif secret.is_a?(String) and secret.size == 0 then
        config['forging']['secret'] = ''
      end

      return config
    end

    def update_config(&block)
      yield config = inspect_config
      ConfigUpdater.update(@task, @node, config)
    end
  end
end
