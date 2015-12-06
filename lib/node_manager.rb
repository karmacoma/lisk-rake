module CryptiKit
  class NodeManager
    def initialize(task)
      @task = task
    end

    def start(auto = false)
      @task.within Core.install_path do
        @task.info 'Starting crypti...'
        @task.execute top_accounts, 'bash', 'crypti.sh', (auto ? 'autostart' : 'start'), '||', ':'
        @task.info '=> Done.'
      end
    end

    def restart
      @task.within Core.install_path do
        @task.info 'Restarting crypti...'
        @task.execute top_accounts, 'bash', 'crypti.sh', 'restart', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop
      return unless install_path?
      @task.within Core.install_path do
        @task.info 'Stopping crypti...'
        @task.execute 'bash', 'crypti.sh', 'stop', '||', ':'
        @task.info '=> Done.'
      end
    end

    private

    def top_accounts
      "TOP=#{Core.top_accounts}"
    end

    def install_path?
      @task.test "[ -d #{Core.install_path} ];"
    end
  end
end
