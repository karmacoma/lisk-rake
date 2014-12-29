module CryptiKit
  class PassphraseManager
    def initialize(task)
      @task = task
    end

    def add(passphrase)
      @task.info 'Adding passphrase to remote config...'
      @passphrase = (add?) ? passphrase : nil
      replace.tap do
        @task.info @passphrase ? '=> Done.' : '=> Skipped.'
      end
    end

    def remove
      @task.info 'Removing passphrase from remote config...'
      @passphrase = nil
      replace.tap do
        @task.info '=> Done.'
      end
    end

    private

    def add?
      print yellow("Add passphrase to remote config?\s")
      STDIN.gets.chomp.match(/y|yes/i)
    end

    def escaped
      if @passphrase.is_a?(Hash) then
        Passphrase.escaped(@passphrase[:secret])
      end
    end

    def sed_expression
      %Q{'s/\\("secretPhrase":\\)\\(.*\\)/\\1 "#{escaped}"/i'}
    end

    def config
      @config ||= Core.install_path + '/config.json'
    end

    def tmp_config
      @tmp_config ||= config + '.bak'
    end

    def replace
      @task.capture 'sed', sed_expression, config, '>', tmp_config
      @task.capture 'mv', tmp_config, config
    end
  end
end
