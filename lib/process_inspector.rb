module CryptiKit
  class ProcessInspector
    def initialize(task)
      @task = task
    end

    def app_pid
      @task.within Core.install_path do
        @task.capture 'cat', 'app.pid', '||', ':'
      end
    end

    def capture
      if (pid = app_pid).to_i == 0 then
        return no_data
      end
      begin
        pstree = @task.capture 'pstree', '-p', pid
        if pstree then
          psids = pstree.scan(/(\([0-9]+\))/)
          psids.collect! { |m| m[0].gsub(/[\(\)]/, '') }

          pstat = @task.capture 'ps', '--no-headers', '-p', psids.join(','), '-o', '%cpu,%mem,etime'
          if pstat then
            stats = pstat.split("\n")
            stats.collect! { |l| l.split("\s") }
          end
        end
      rescue Exception => exception
        return no_data
      end
      if stats.is_a?(Array) and stats.size > 0 then
        data = []
        data[0] = stats.reduce(0.0) { |sum, n| sum + n[0].to_f }.round(2)
        data[1] = stats.reduce(0.0) { |sum, n| sum + n[1].to_f }.round(2)
        data[2] = stats[0][2]
        data
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

    def etime
      data[2]
    end

    def success?
      data.size == 3
    end

    def to_h
      hash = {}
      ['cpu', 'mem', 'etime'].each_with_index do |v,i|
        hash[v] = data[i]
      end
      hash['success'] = success?
      hash
    end
  end
end
