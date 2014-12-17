class ProcessInspector
  def initialize(task, forever)
    @task    = task
    @forever = forever
  end

  def capture
    if (pid = @forever.app_pid.to_i) == 0 then
      return no_data
    end
    begin
      output = @task.capture 'ps', '-p', pid, '-o', '%cpu,%mem'
    rescue Exception => exception
      return no_data
    end
    match = output.match(/^(%CPU %MEM)\n([0-9\s.]+)$/)
    if match.is_a?(MatchData) and match.size == 3 then
      match[2].split("\s").collect! { |m| m.to_f }
    else
      no_data
    end
  end

  def data
    @data ||= capture
  end

  def no_data; [] end

  def cpu
    data[0]
  end

  def mem
    data[1]
  end

  def to_h
    hash = {}
    ['cpu', 'mem'].each_with_index do |v,i|
      hash[v] = data[i]
    end
    hash
  end
end
