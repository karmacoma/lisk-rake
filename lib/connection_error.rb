class ConnectionError
  def initialize(task, exception)
    @task      = task
    @exception = exception
  end

  def detect_error
    case @exception.to_s
    when /Authentication failed/ then
      authentication_failure
    when /Connection closed/i then
      connection_closed
    when /Connection timed out/ then
      connection_timeout
    when /Connection refused/ then
      connection_refused
    else
      unknown_error
    end
  end

  def authentication_failure
    @task.error '=> Authentication failed.'
  end

  def connection_closed
    @task.error '=> Connection closed by remote host.'
  end

  def connection_timeout
    @task.error '=> Connection timed out.'
  end

  def connection_refused
    @task.error '=> Connection refused.'
  end

  def unknown_error
    if ENV['debug'] == 'true' then
      raise @exception
    else
      @task.error (@exception.to_s.size > 0) ? '=> ' + @exception.to_s : '=> Unknown error.'
    end
  end
end
