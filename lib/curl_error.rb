module CryptiKit
  class CurlError < BasicError
    def detect
      case @exception.to_s
      when /curl exit status: 7/ then
        message = connection_failed
      when /curl exit status: 28/ then
        message = operation_timeout
      else
        message = (@exception.class == Interrupt) ? query_interrupted : unknown_error
      end
      @task.error '=> API query failed. Check crypti node is running and blockchain is loaded.'
      @task.error message
      return message
    end

    def connection_failed
      '=> Connection failed.'
    end

    def operation_timeout
      '=> Operation timed out.'
    end

    def query_interrupted
      '=> Query interrupted.'
    end
  end
end
