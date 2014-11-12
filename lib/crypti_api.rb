require 'json'
require 'uri'

class CryptiApi
  def initialize(task)
    @task = task
  end

  DEFAULT_ARGS = [
    '--silent',
    '--header', '"Content-Type: application/json"'
  ]

  def get(url, data = nil, &block)
    begin
      body = @task.capture *curl('-X', 'GET', encode_url(url, data))
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
      body = @task.capture *curl('-X', 'POST', '-d', "'#{data.to_json}'", encode_url(url))
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
    '\'http://127.0.0.1:6040' + url << (data ? "?#{URI.encode_www_form(data)}" : '') + '\''
  end

  def error_message(exception)
    @task.error '=> API query failed. Check crypti node is running and blockchain is loaded.'
    @task.error '=> Error: ' + (exception.to_s || 'Unknown error.')
  end

  private

  def curl(*args)
    ['curl', DEFAULT_ARGS, args].flatten!
  end
end
