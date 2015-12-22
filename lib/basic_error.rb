module CryptiKit
  class BasicError
    def initialize(task, exception)
      @task      = task
      @exception = exception
    end

    class << self
      attr_reader :errors
    end

    @errors = {}

    def detect
      interrupt?
      message ||= known_error
      message ||= unknown_error
      @task.error message if message.is_a?(String)
      return message
    end

    private

    def interrupt?
      if @exception.is_a?(Interrupt) then
        puts
        @task.error '=> Connection interrupted.'
        exit!
      end
    end

    def known_error
      excep = @exception.to_s
      error = self.class.errors.find { |k,v| excep =~ k }
      error = error.last if error.is_a?(Array)
      send(error)        if error.is_a?(Symbol)
      return error
    end

    def unknown_error
      if ENV['debug'] != 'true' then
        (@exception.to_s.size > 0) ? '=> ' + @exception.to_s : '=> Unknown error.'
      else
        raise @exception
      end
    end
  end
end
