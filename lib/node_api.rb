class NodeApi
  def initialize(task)
    @task = task
    @api  = CryptiApi.new(@task)
  end

  def loading_status
    @task.info 'Getting loading status...'
    @api.get '/api/getLoading' do |json|
      @task.info '=> Done.'
    end
  end

  def mining_info(public_key)
    @task.info 'Getting mining info...'
    if public_key then
      @api.get '/api/getMiningInfo', { publicKey: public_key, descOrder: true } do |json|
        @task.info '=> Done.'
      end
    else
      @task.warn '=> Mining info not available.'
      {}
    end
  end

  def account_balance(account)
    @task.info 'Getting account balance...'
    if account then
      @api.get '/api/getBalance', { address: account } do |json|
        @task.info '=> Done.'
      end
    else
      @task.warn '=> Account balance not available.'
      {}
    end
  end

  def node_status(node, &block)
    json = { 'info' => node.info, 'loading_status' => loading_status, 'mining_info' => mining_info(node.public_key), 'account_balance' => account_balance(node.account) }
    ['loading_status', 'mining_info', 'account_balance'].each do |j|
      json[j].merge!('key' => node.key)
    end
    block.call(json) if block_given?
    json
  end
end
