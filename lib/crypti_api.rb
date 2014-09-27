require 'uri'

class CryptiApi
  def initialize(task)
    @task = task
  end

  def get(url, data = nil, &block)
    begin
      body = @task.capture 'curl', '-sX', 'GET', '-H', '"Content-Type: application/json"', encode_url(url, data)
      json = JSON.parse(body)
    rescue Exception => exception
      error_message(exception)
      json = {}
    end
    if block_given? and json['success'] then
      block.call json
    end
    return json
  end

  def post(url, data = {}, &block)
    begin
      body = @task.capture 'curl', '-sX', 'POST', '-H', '"Content-Type: application/json"', '-d', "'#{data.to_json}'", encode_url(url)
      json = JSON.parse(body)
    rescue Exception => exception
      error_message(exception)
      json = {}
    end
    if block_given? and json['success'] then
      block.call json
    end
    return json
  end

  def encode_url(url, data = nil)
    encoded = 'http://127.0.0.1:6040' + url
    encoded << '?' + URI.encode_www_form(data) if data
    encoded = "'#{encoded}'"
  end

  def error_message(exception)
    @task.error '=> API query failed. Check crypti node is running and blockchain is fully loaded.'
    @task.error '=> Error: ' + exception.to_s
  end

  def loading_status
    @task.info 'Getting loading status...'
    get '/api/getLoading' do |json|
      @task.info '=> Done.'
    end
  end

  def mining_info(public_key)
    @task.info 'Getting mining info...'
    if public_key then
      get '/api/getMiningInfo', { publicKey: public_key, descOrder: true } do |json|
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
      get '/api/getBalance', { address: account } do |json|
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
