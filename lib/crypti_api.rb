require 'uri'

class CryptiApi
  def initialize(task)
    @task = task
  end

  def get(url, data = nil, &block)
    begin
      body = @task.capture 'curl', '-X', 'GET', '-H', '"Content-Type: application/json"', encode_url(url, data)
      json = JSON.parse(body)
    rescue Exception => exception
      @task.info error_message
      json = {}
    end
    if block_given? and json['success'] then
      block.call json
    end
    return json
  end

  def post(url, data = {}, &block)
    begin
      body = @task.capture 'curl', '-X', 'POST', '-H', '"Content-Type: application/json"', '-d', "'#{data.to_json}'", encode_url(url)
      json = JSON.parse(body)
    rescue Exception => exception
      @task.info error_message
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
    encoded
  end

  def error_message
    'API query failed. Check crypti node is running and blockchain is fully loaded.'
  end

  def loading_status
    @task.info 'Getting loading status...'
    get '/api/getLoading' do |json|
      @task.info 'Done.'
    end
  end

  def forging_status
    @task.info 'Getting forging status...'
    get '/forgingApi/getForgingInfo' do |json|
      @task.info 'Done.'
    end
  end

  def account_balance(account)
    @task.info 'Getting account balance...'
    if account then
      get '/api/getBalance', { address: account } do |json|
        @task.info 'Done.'
      end
    else
      {}
    end
  end

  def node_status(node, &block)
    @task.info node.info
    json = { 'info' => node.info, 'loading_status' => loading_status, 'forging_status' => forging_status, 'account_balance' => account_balance(node.account) }
    block.call(json) if block_given?
    json
  end
end
