require 'basic_error'

module CryptiKit
  class ServerError < BasicError
    def collect(node, error)
      { 'key' => node.key, 'error' => error.detect }
    end

    def detect
      case @exception.to_s
      when /Authentication failed/ then
        message = authentication_failure
      when /Network is unreachable/i then
        message = network_unreachable
      when /Connection closed/i then
        message = connection_closed
      when /Connection timed out/ then
        message = connection_timeout
      when /Connection refused/ then
        message = connection_refused
      else
        message = (@exception.class == Interrupt) ? connection_interrupted : unknown_error
      end
      @task.error message
      return message
    end

    private

    def authentication_failure
      '=> Authentication failed.'
    end

    def network_unreachable
      '=> Network is unreachable.'
    end

    def connection_closed
      '=> Connection closed by remote host.'
    end

    def connection_timeout
      '=> Connection timed out.'
    end

    def connection_refused
      '=> Connection refused.'
    end

    def connection_interrupted
      '=> Connection interrupted.'
    end
  end
end
