class CryptiApi
  def initialize(task)
    @task = task
  end

  def get(url)
    body = @task.capture 'curl', '-X', 'GET', '-H', '"Content-Type: application/json"', 'http://127.0.0.1:6040' + url
    JSON.parse(body)
  rescue Exception => exception
    @task.info error_message
    {}.to_json
  end

  def post(url, data)
    @task.execute 'curl', '-X', 'POST', '-H', '"Content-Type: application/json"', '-d', "'#{data}'", 'http://127.0.0.1:6040' + url
  rescue
    @task.info error_message
  end

  def error_message
    'API query failed. Check crypti node is running and blockchain is fully loaded.'
  end

  def silent_post(url, data)
    SSHKit.config.output_verbosity = Logger::WARN
    post(url, data)
  ensure
    SSHKit.config.output_verbosity = Logger::INFO
  end
end
