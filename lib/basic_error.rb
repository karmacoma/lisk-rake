module CryptiKit
  class BasicError
    def initialize(task, exception)
      @task      = task
      @exception = exception
    end

    def detect
      unknown_error
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
