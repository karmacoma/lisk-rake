class ServerError
  def initialize(task, exception)
    @task      = task
    @exception = exception
  end

  def collect(node, error)
    { 'key' => node.key, 'error' => error.detect }
  end

  def detect
    case @exception.to_s
    when /Authentication failed/ then
      message = authentication_failure
    when /Connection closed/i then
      message = connection_closed
    when /Connection timed out/ then
      message = connection_timeout
    when /Connection refused/ then
      message = connection_refused
    else
      message = unknown_error
    end
    @task.error message
    return message
  end

  def authentication_failure
    '=> Authentication failed.'
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

  def unknown_error
    if ENV['debug'] == 'true' then
      raise @exception
    else
      (@exception.to_s.size > 0) ? '=> ' + @exception.to_s : '=> Unknown error.'
    end
  end
end
