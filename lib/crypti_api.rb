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
    block.call json if block_given?
    return json
  end

  def post(url, data, &block)
    begin
      body = @task.capture 'curl', '-X', 'POST', '-H', '"Content-Type: application/json"', '-d', "'#{data.to_json}'", encode_url(url)
      json = JSON.parse(body)
    rescue Exception => exception
      @task.info error_message
      json = {}
    end
    block.call json if block_given?
    return json
  end

  def encode_url(url, data = nil)
    _url = 'http://127.0.0.1:6040' + url
    _url + '?' + URI.encode_www_form(data) if data
    _url
  end

  def error_message
    'API query failed. Check crypti node is running and blockchain is fully loaded.'
  end
end
