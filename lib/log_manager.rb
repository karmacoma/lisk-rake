module CryptiKit
  class LogManager
    def initialize(task)
      @task = task
    end

    def delete_previous
      @task.info 'Deleting previous logs...'
      @task.execute 'mkdir', '-p', 'logs'
      @task.within 'logs' do
        @task.execute 'rm', '-f', '*.log'
      end
    end

    def download_forever
      @task.info 'Downloading forever log...'
      forever = ForeverInspector.new(@task)
      if @task.test 'ls', forever.log_file then
        @task.download! forever.log_file, "logs/#{@node.key}.forever.log"
        @task.info '=> Done.'
      else
        @task.warn '=> Not found.'
      end
    end

    def download_crypti
      @task.info 'Downloading crypti log...'
      if @task.test 'ls', Core.log_file then
        @task.download! Core.log_file, "logs/#{@node.key}.crypti.log"
        @task.info '=> Done.'
      else
        @task.warn '=> Not found.'
      end
    end

    def download(node)
      @node = node
      delete_previous
      download_forever
      download_crypti
    end

    def clean
      @task.within Core.install_path do
        @task.info 'Truncating existing crypti log...'
        @task.execute 'truncate', 'logs.log', '--size', '0'
        @task.info 'Removing old crypti log(s)...'
        @task.execute 'rm', '-f', 'logs.old.*'
      end
      @task.info 'Removing old forever log(s)...'
      @task.execute 'forever', 'cleanlogs'
      @task.info '=> Done.'
    end
  end
end
