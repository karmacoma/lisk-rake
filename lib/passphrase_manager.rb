module CryptiKit
  class PassphraseManager
    def initialize(task)
      @task = task
    end

    def add_passphrase(passphrase)
      @task.info 'Adding passphrase to remote config...'
      @passphrase = (add_passphrase?) ? passphrase : nil
      replace_passphrase
      @task.info @passphrase ? '=> Done.' : '=> Skipped.'
    end

    def remove_passphrase
      @task.info 'Removing passphrase from remote config...'
      @passphrase = nil
      replace_passphrase
      @task.info '=> Done.'
    end

    private

    def add_passphrase?
      print yellow("Add passphrase to remote config?\s")
      STDIN.gets.chomp.match(/y|yes/i)
    end

    def escaped_passphrase
      if @passphrase.is_a?(Hash) then
        Passphrase.escaped(@passphrase[:secret])
      end
    end

    def sed_expression
      %Q{'s/\\("secretPhrase":\\)\\(.*\\)/\\1 "#{escaped_passphrase}"/i'}
    end

    def config
      @config ||= Core.install_path + '/config.json'
    end

    def tmp_config
      @tmp_config ||= config + '.bak'
    end

    def replace_passphrase
      @task.capture 'sed', sed_expression, config, '>', tmp_config
      @task.capture 'mv', tmp_config, config
    end
  end
end
