module CryptiKit
  class AccountInspector
    def initialize(inspector, node)
      @inspector = inspector
      @node      = node
    end

    def inspect
      @node.accounts.each_with_index do |account,i|
        @account    = account['address']
        @public_key = account['public_key']

        accounts.push(to_json(i))
      end

      { 'accounts' => accounts,
        'success'  => (accounts.size > 0) }
    end

    def accounts
      @accounts ||= []
    end

    def task
      @inspector.task
    end

    def api
      @inspector.api
    end

    def loaded
      @inspector.loaded
    end

    def self.inspect(task, node)
      self.new(task, node).inspect
    end

    private

    def delegate_status
      task.info 'Getting delegate status...'
      if loaded then
        api.get '/api/delegates/get', { publicKey: @public_key } do |json|
          task.info '=> Done.'
        end
      else
        task.warn '=> Delegate status not available.'
        {}
      end
    end

    def forging_status
      task.info 'Getting forging status...'
      if loaded then
        api.get '/api/delegates/forging/status', { publicKey: @public_key } do |json|
          task.info '=> Done.'
        end
      else
        task.warn '=> Forging status not available.'
        {}
      end
    end

    def forged_coinage
      task.info 'Getting forged coinage...'
      api.get '/api/delegates/forging/getForgedByAccount', { generatorPublicKey: @public_key } do |json|
        task.info '=> Done.'
      end
    end

    def forged_blocks
      task.info 'Getting forged blocks...'
      api.get '/api/blocks', { generatorPublicKey: @public_key, orderBy: 'height:desc', limit: 1 } do |json|
        task.info '=> Done.'
      end
    end

    def forging_info
      if @public_key then
        json = forged_coinage
        json.merge!(forged_blocks) if json['success']
        json
      else
        task.warn '=> Forging info not available.'
        {}
      end
    end

    def account_balance
      task.info 'Getting account balance...'
      if @account then
        api.get '/api/accounts/getBalance', { address: @account } do |json|
          task.info '=> Done.'
        end
      else
        task.warn '=> Account balance not available.'
        {}
      end
    end

    def to_json(i)
      json = {
        'delegate_status' => delegate_status,
        'forging_status'  => forging_status,
        'forging_info'    => forging_info,
        'account_balance' => account_balance
      }
      json.keys.each do |k|
        json[k].merge!(
          'key'      => @node.key,
          'index'    => (i + 1),
          'username' => username(json)
        )
      end
      json
    end

    def username(json)
      json['delegate_status']['delegate']['username'] rescue '~'
    end
  end
end
