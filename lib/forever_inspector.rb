module CryptiKit
  class ForeverInspector
    def initialize(task)
      @task = task
      @proc = ProcessInspector.new(task, self)
    end

    def capture
      output = @task.capture 'forever', '--plain', 'list'
      match  = output.match(/^.*\b(app.js)\b.*$/)
      result = match.is_a?(MatchData) ? match[0].split.join("\s") : ''
      result.gsub!(/data: \[0\] /, '') if result.size > 0
      result.split("\s")
    end

    def data
      @data ||= capture
    end

    def uid
      data[0]
    end

    def command
      data[1]
    end

    def script
      data[2]
    end

    def forever_pid
      data[3]
    end

    def app_pid
      data[4]
    end

    def log_file
      data[5]
    end

    def uptime
      data[6]
    end

    def success?
      data.size == 7
    end

    def to_h
      hash = {}
      ['uid', 'command', 'script', 'forever_pid', 'app_pid', 'log_file', 'uptime'].each_with_index do |v,i|
        hash[v] = data[i]
      end
      hash['success'] = success?
      hash.merge!(@proc.to_h)
      hash
    end
  end
end
