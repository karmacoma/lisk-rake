module CryptiKit
  class NodeManager
    def initialize(task)
      @task = task
    end

    def start
      stop do
        @task.within Core.install_path do
          @task.info 'Starting crypti node...'
          @task.execute top_accounts?, 'forever', 'start', 'app.js', '||', ':'
          @task.info '=> Done.'
        end
      end
    end

    def restart
      @task.within Core.install_path do
        @task.info 'Restarting crypti node...'
        @task.execute top_accounts?, 'forever', 'restart', 'app.js', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop(&block)
      return unless install_path?
      @task.within Core.install_path do
        @task.info 'Stopping crypti node...'
        @task.execute 'forever', 'stop', 'app.js', '||', ':'
        @task.info '=> Done.'
      end
      yield if block_given?
    end

    private

    def top_accounts?
      "TOP=#{Core.top_accounts}"
    end

    def install_path?
      @task.test "[ -d #{Core.install_path} ];"
    end
  end
end
