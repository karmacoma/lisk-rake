module CryptiKit
  class AccountManager
    def initialize(task, server)
      @task    = task
      @server  = server
      @list    = AccountList.new
      @manager = PassphraseManager.new(task)
    end

    def add_account(json, passphrase)
      @task.info 'Adding account...'
      if json.is_a?(Hash) and json['forging'] then
        @list[key] = json
        @list.save
        @task.info "=> Added: #{account(json)}."
        @manager.add_passphrase(passphrase)
      else
        @task.error '=> Failed. Check passphrase.'
      end
    end

    def remove_account(json)
      @task.info 'Removing account...'
      if json.is_a?(Hash) and !json['forgingEnabled'] then
        @list.remove(key)
        @list.save
        @task.info "=> Removed: #{account(json)}."
        @manager.remove_passphrase
      else
        @task.error '=> Failed. Check passphrase.'
      end
    end

    private

    def key
      Core.config['servers'].key(@server.to_s)
    end

    def account(json)
      json['address'] || json['account'] || json['error']
    end
  end
end
