module CryptiKit
  class NodeManager
    def initialize(task, node)
      @task = task
      @node = node
    end

    def start(auto = false)
      @task.within @node.crypti_path do
        @task.info 'Starting crypti...'
        @task.execute top_accounts, 'bash', 'crypti.sh', (auto ? 'autostart' : 'start'), '||', ':'
        @task.info '=> Done.'
      end
    end

    def restart
      @task.within @node.crypti_path do
        @task.info 'Restarting crypti...'
        @task.execute top_accounts, 'bash', 'crypti.sh', 'restart', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop
      return unless crypti_path?
      @task.within @node.crypti_path do
        @task.info 'Stopping crypti...'
        @task.execute 'bash', 'crypti.sh', 'stop', '||', ':'
        @task.info '=> Done.'
      end
    end

    private

    def top_accounts
      "TOP=#{Core.top_accounts}"
    end

    def crypti_path?
      @task.test "[ -d #{@node.crypti_path} ];"
    end
  end
end
