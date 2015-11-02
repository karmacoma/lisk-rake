module CryptiKit
  class ForeverService
    def initialize(task)
      @task = task
    end

    def install
      @task.info 'Installing forever service...'
      @task.execute 'forever-service', 'install', 'crypti', '-e', "'#{top_accounts?}'"
    end

    def uninstall
      @task.info 'Uninstalling forever service...'
      @task.execute 'forever-service', 'delete', 'crypti'
    end

    private

    def top_accounts?
      "TOP=#{Core.top_accounts}"
    end
  end
end
