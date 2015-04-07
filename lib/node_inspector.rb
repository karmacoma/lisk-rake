require 'json'

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

    def config_status
      @task.info 'Getting configuration...'
      conf = @task.capture 'cat', "#{Core.install_path}/config.json"
      json = JSON.parse(conf) rescue {}
      if !json.empty? then
        @task.info '=> Done.'
        json['success'] = true
      else
        @task.warn '=> Configuration not available.'
        json['success'] = false
      end
      ConfigInspector.inspect(json)
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

    def delegate_status
      @task.info 'Getting delegate status...'
      if loaded then
        @api.get '/api/delegates/get', { publicKey: @public_key } do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Delegate status not available.'
        {}
      end
    end

    def forging_status
      @task.info 'Getting forging status...'
      if loaded then
        @api.get '/api/delegates/forging/status', { publicKey: @public_key } do |json|
          @task.info '=> Done.'
        end
      else
        @task.warn '=> Forging status not available.'
        {}
      end
    end

    def forged_coinage
      @task.info 'Getting forged coinage...'
      @api.get '/api/delegates/forging/getForgedByAccount', { generatorPublicKey: @public_key } do |json|
        @task.info '=> Done.'
      end
    end

    def forged_blocks
      @task.info 'Getting forged blocks...'
      @api.get '/api/blocks', { generatorPublicKey: @public_key, orderBy: 'height:desc', limit: 1 } do |json|
        @task.info '=> Done.'
      end
    end

    private :forged_coinage, :forged_blocks

    def forging_info
      if synced and @public_key then
        json = forged_coinage
        json.merge!(forged_blocks) if json['success']
        json
      else
        @task.warn '=> Forging info not available.'
        {}
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
        json['config_status']   = config_status
        json['forever_status']  = forever_status
        json['loading_status']  = loading_status
        json['sync_status']     = loaded ? sync_status : {}
        json['block_status']    = loaded && synced ? block_status : {}
        json['delegate_status'] = delegate_status
        json['forging_status']  = forging_status
        json['forging_info']    = forging_info
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
