require 'json'

module CryptiKit
  class NodeInspector
    attr_reader :task, :node, :api

    def initialize(task, node)
      @task = task
      @node = node
      @api  = Curl.new(@task)
    end

    def process_status
      @task.info 'Getting process status...'
      @task.with path: '/usr/local/bin:$PATH' do
        @process = ProcessInspector.new(@task, @node)
        if @process.success? then
          @task.info '=> Done.'
        else
          @task.warn '=> Process status not available.'
        end
        @process.to_h
      end
    end

    def config_status
      config = ConfigInspector.inspect(@task, @node)
      config['forging']['secret'] = [] if config['forging']
      config
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

    def self.loaded?(task, node)
      klass = self.new(task, node)
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

    attr_reader :synced

    def block_status
      @task.info 'Getting blockchain status...'
      @api.get '/api/blocks/getHeight' do |json|
        @task.info '=> Done.'
      end
    end

    private :block_status

    def node_status(&block)
      json = {
        'info'            => node.info,
        'config_status'   => config_status,
        'process_status'  => process_status,
        'loading_status'  => loading_status,
        'sync_status'     => (loaded ? sync_status : {}),
        'block_status'    => (loaded && synced ? block_status : {}),
        'accounts_status' => AccountInspector.inspect(self, @node)
      }
      json.keys.reject! { |k| k == 'info' }.each do |j|
        json[j].merge!('key' => node.key)
      end
      block.call(json) if block_given?
      json
    end
  end
end
