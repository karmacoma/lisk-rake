class CryptiApi
  def initialize(task)
    @task = task
  end

  def get(url, &block)
    begin
      body = @task.capture 'curl', '-X', 'GET', '-H', '"Content-Type: application/json"', 'http://127.0.0.1:6040' + url
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
      body = @task.capture 'curl', '-X', 'POST', '-H', '"Content-Type: application/json"', '-d', "'#{data.to_json}'", 'http://127.0.0.1:6040' + url
      json = JSON.parse(body)
    rescue Exception => exception
      @task.info error_message
      json = {}
    end
    block.call json if block_given?
    return json
  end

  def error_message
    'API query failed. Check crypti node is running and blockchain is fully loaded.'
  end
end
