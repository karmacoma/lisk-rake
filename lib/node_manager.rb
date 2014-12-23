module CryptiKit
  class NodeManager
    def initialize(task)
      @task = task
    end

    def start
      stop
      @task.within Core.install_path do
        @task.info 'Starting crypti node...'
        @task.execute 'forever', 'start', 'app.js', '||', ':'
        @task.info '=> Done.'
      end
    end

    def restart
      @task.within Core.install_path do
        @task.info 'Restarting crypti node...'
        @task.execute 'forever', 'restart', 'app.js', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop
      @task.within Core.install_path do
        @task.info 'Stopping crypti node...'
        @task.execute 'forever', 'stop', 'app.js', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop_all
      @task.info 'Stopping all processes...'
      @task.execute 'forever', 'stopall', '||', ':'
      @task.info '=> Done.'
    end
  end
end
