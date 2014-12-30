module CryptiKit
  class NodeInspector
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
      @api.get '/api/loader/status' do |json|
        if (@loaded = json['loaded']) then
          @task.info '=> Done.'
        else
          @task.warn '=> Loading in progress.'
        end
      end
    end

    attr_reader :loaded

    def self.loaded?(task)
      klass = self.new(task)
      klass.loading_status
      klass.loaded
    end

    def sync_status
      @task.info 'Getting sync status...'
      @api.get '/api/loader/status/sync' do |json|
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
      @api.get '/api/blocks/getHeight' do |json|
        @task.info '=> Done.'
      end
    end

    private :block_status

    def forging_status
      @task.info 'Getting forging status...'
      if loaded then
        @api.get '/api/forging' do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Forging status not available.'
        {}
      end
    end

    def mined_coinage
      @task.info 'Getting mined coinage...'
      @api.get '/api/blocks/getForgedByAccount', { generatorPublicKey: @public_key } do |json|
        @task.info '=> Done.'
      end
    end

    def mined_blocks
      @task.info 'Getting mined blocks...'
      @api.get '/api/blocks', { generatorPublicKey: @public_key, orderBy: 'height:desc', limit: 1 } do |json|
        @task.info '=> Done.'
      end
    end

    private :mined_coinage, :mined_blocks

    def mining_info
      if synced and @public_key and mining_info_enabled? then
        json = mined_coinage
        json.merge!(mined_blocks) if json['success']
        json
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

    def account_balance
      @task.info 'Getting account balance...'
      if synced and @account then
        @api.get '/api/accounts/getBalance', { address: @account } do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Account balance not available.'
        {}
      end
    end

    def yield_node(node, &block)
      @account    = node.account
      @public_key = node.public_key
      yield node
    end

    private :yield_node

    def node_status(node, &block)
      yield_node(node) do |node|
        json                    = { 'info' => node.info }
        json['forever_status']  = forever_status
        json['loading_status']  = loading_status
        json['sync_status']     = loaded ? sync_status : {}
        json['block_status']    = loaded && synced ? block_status : {}
        json['forging_status']  = forging_status
        json['mining_info']     = mining_info
        json['account_balance'] = account_balance
        json.keys.reject! { |k| k == 'info' }.each do |j|
          json[j].merge!('key' => node.key)
        end
        block.call(json) if block_given?
        json
      end
    end
  end
end
