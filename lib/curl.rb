require 'json'
require 'uri'

module LiskRake
  class Curl
    def initialize(task)
      @task = task
    end

    DEFAULT_ARGS = [
      '--silent',
      '--header', '"Content-Type: application/json"',
      '--connect-timeout', '30',
      '--max-time', '60'
    ]

    def get(url, data = nil, &block)
      begin
        body = @task.capture *curl('-X', 'GET', encode_url(url, data))
        json = JSON.parse(body)
      rescue Exception => exception
        error = CurlError.new(@task, exception)
        error.detect
        json = {}
      end
      if block_given? then
        block.call json
      end
      return json
    end

    ESCAPED_CHARS = {
      /'/ => '\u0027',
      /`/ => '\u0060'
    }

    def post(url, data = {}, method = 'POST', &block)
      begin
        data = data.to_json
        ESCAPED_CHARS.each_pair { |k,v| data.gsub!(k, &Proc.new { v }) }
        body = @task.capture *curl('-X', method, '-d', "'#{data}'", encode_url(url))
        json = JSON.parse(body)
      rescue Exception => exception
        error = CurlError.new(@task, exception)
        error.detect
        json = {}
      end
      if block_given? then
        block.call json
      end
      return json
    end

    def put(url, data = {}, &block)
      post(url, data, 'PUT', &block)
    end

    def encode_url(url, data = nil)
      url  = "'http://127.0.0.1:#{Core.app_port}#{url}"
      url << "?#{URI.encode_www_form(data)}" if data
      url << "'"
      url
    end

    private

    def curl(*args)
      ['curl', DEFAULT_ARGS, args].flatten!
    end
  end
end
