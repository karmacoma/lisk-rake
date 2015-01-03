module CryptiKit
  class NodeApi
    def initialize(task)
      @task = task
      @api  = Curl.new(@task)
    end

    def forever_status
      @task.info 'Getting forever status...'
      @forever = ForeverInspector.new(@task)
      if @forever.success? then
        @task.info '=> Done.'
      else
        @task.warn '=> Forever status not available.'
      end
      @forever.to_h
    end

    def loading_status
      @task.info 'Getting loading status...'
      @api.get '/api/getLoading' do |json|
        if (@loaded = json['loaded']) then
          @task.info '=> Done.'
        else
          @task.warn '=> Loading in progress.'
        end
      end
    end

    attr_reader :loaded

    def sync_status
      @task.info 'Getting sync status...'
      @api.get '/api/isSync' do |json|
        if (@synced = !json['sync']) then
          @task.info '=> Done.'
        else
          @task.warn '=> Synchronisation in progress.'
        end
      end
    end

    def synced
      @loaded and @synced
    end

    def block_status
      @task.info 'Getting blockchain status...'
      @api.get '/api/getHeight' do |json|
        @task.info '=> Done.'
      end
    end

    private :block_status

    def forging_status
      @task.info 'Getting forging status...'
      if loaded then
        @api.get '/forgingApi/getForgingInfo' do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Forging status not available.'
        {}
      end
    end

    def mining_info(public_key)
      @task.info 'Getting mining info...'
      if synced and public_key and mining_info_enabled? then
        @api.get '/api/getMiningInfo', { publicKey: public_key, descOrder: true } do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Mining info not available.'
        {}
      end
    end

    def mining_info_enabled?
      [Core.mining_info, ENV['mining_info']].any? do |v|
        v == 'true' or v == 'enabled'
      end
    end

    def account_balance(account)
      @task.info 'Getting account balance...'
      if synced and account then
        @api.get '/api/getBalance', { address: account } do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Account balance not available.'
        {}
      end
    end

    def node_status(node, &block)
      json                    = { 'info' => node.info }
      json['forever_status']  = forever_status
      json['loading_status']  = loading_status
      json['sync_status']     = loaded ? sync_status : {}
      json['block_status']    = loaded && synced ? block_status : {}
      json['forging_status']  = forging_status
      json['mining_info']     = mining_info(node.public_key)
      json['account_balance'] = account_balance(node.account)
      json.keys.reject! { |k| k == 'info' }.each do |j|
        json[j].merge!('key' => node.key)
      end
      block.call(json) if block_given?
      json
    end
  end
end
