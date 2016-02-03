module LiskRake
  class LogManager
    def initialize(task, node)
      @task = task
      @node = node
    end

    def download
      delete_previous
      @task.within @node.lisk_path do
        download_app_log
        download_logs_log
      end
    end

    def clean
      @task.within @node.lisk_path do
        @task.info 'Truncating existing logs...'
        @task.execute 'truncate', 'app.log', 'logs.log', '--size', '0'
        @task.info 'Removing rotated logs...'
        @task.execute 'rm', '-f', 'logs.old.*'
        @task.info '=> Done.'
      end
    end

    private

    def delete_previous
      run_locally do
        info 'Deleting previous logs...'
        execute 'mkdir', '-p', 'logs'
        within 'logs' do
          execute 'rm', '-f', '*.log'
        end
      end
    end

    def app_log
      @app_log ||= "#{@node.lisk_path}/app.log"
    end

    def download_app_log
      @task.info 'Downloading app.log...'
      if @task.test 'ls', app_log then
        @task.download! app_log, "logs/#{@node.key}.app.log"
        @task.info '=> Done.'
      else
        @task.warn '=> Not found.'
      end
    end

    def logs_log
      @logs_log ||= "#{@node.lisk_path}/logs.log"
    end

    def download_logs_log
      @task.info 'Downloading logs.log...'
      if @task.test 'ls', logs_log then
        @task.download! logs_log, "logs/#{@node.key}.logs.log"
        @task.info '=> Done.'
      else
        @task.warn '=> Not found.'
      end
    end
  end
end
