module LiskRake
  class AccountManager
    def initialize(task, node)
      @task = task
      @node = node
      @api  = Curl.new(@task)
      @list = AccountList.new(node)
    end

    def add(passphrase)
      @task.info 'Adding account...'
      json = @api.post '/api/accounts/open', passphrase
      if json['success'] and json['account'] then
        @list.add(json['account'])
        @list.save
        @task.info "=> Added: #{json['account']['address']}."
        manager = PassphraseManager.new(@task, @node)
        manager.add(passphrase)
      else
        @task.error '=> Failed.'
      end
    end

    def remove(passphrase)
      @task.info 'Removing account...'
      json = @api.post '/api/accounts/open', passphrase
      if json['success'] and json['account'] then
        @list.remove(json['account'])
        @list.save
        @task.info "=> Removed: #{json['account']['address']}."
        manager = PassphraseManager.new(@task, @node)
        manager.remove(passphrase)
      else
        @task.error '=> Failed.'
      end
    end
  end
end
