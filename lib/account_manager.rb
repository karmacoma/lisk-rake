module CryptiKit
  class AccountManager
    def initialize(task, server)
      @task   = task
      @server = server
      @api    = Curl.new(@task)
      @list   = AccountList.new
    end

    def add(passphrase)
      @task.info 'Adding account...'
      json = @api.post '/api/accounts/open', passphrase
      if json['success'] and json['account'] then
        @list[key] = json['account']
        @list.save
        @task.info "=> Added: #{json['account']['address']}."
        manager = PassphraseManager.new(@task)
        manager.add(passphrase)
      else
        @task.error '=> Failed.'
      end
    end

    def remove(passphrase)
      @task.info 'Removing account...'
      json = @api.post '/api/accounts/open', passphrase
      if json['success'] and json['account'] then
        @list.remove(key)
        @list.save
        @task.info "=> Removed: #{json['account']['address']}."
        manager = PassphraseManager.new(@task)
        manager.remove
      else
        @task.error '=> Failed.'
      end
    end

    private

    def key
      Core.configured_servers.key(@server.to_s)
    end
  end
end
