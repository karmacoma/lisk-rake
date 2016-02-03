module LiskRake
  class NodeManager
    def initialize(task, node)
      @task = task
      @node = node
    end

    def start(auto = false)
      @task.within @node.lisk_path do
        @task.info 'Starting lisk...'
        @task.execute top_accounts, 'bash', 'lisk.sh', (auto ? 'autostart' : 'start'), '||', ':'
        @task.info '=> Done.'
      end
    end

    def restart
      @task.within @node.lisk_path do
        @task.info 'Restarting lisk...'
        @task.execute top_accounts, 'bash', 'lisk.sh', 'restart', '||', ':'
        @task.info '=> Done.'
      end
    end

    def stop
      return unless lisk_path?
      @task.within @node.lisk_path do
        @task.info 'Stopping lisk...'
        @task.execute 'bash', 'lisk.sh', 'stop', '||', ':'
        @task.info '=> Done.'
      end
    end

    private

    def top_accounts
      "TOP=#{Core.top_accounts}"
    end

    def lisk_path?
      @task.test "[ -d #{@node.lisk_path} ];"
    end
  end
end
