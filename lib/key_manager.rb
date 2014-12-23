module CryptiKit
  class KeyManager
    def initialize(task)
      @task = task
    end

    def find
      @task.info 'Looking for public ssh key...'
      if @task.test 'ls', Core.deploy_key then
        @task.info '=> Found.'
      else
        @task.warn '=> Could not find ssh key. Creating a new one...'
        system 'ssh-keygen -t rsa'
      end
    end

    def add(server)
      find.tap do
        @task.info "Adding public ssh key to: #{server}..."
        @task.execute 'ssh-copy-id', '-i', Core.deploy_key, "#{Core.deploy_user_at_host(server)}"
        @task.info '=> Done.'
      end
    rescue Exception => exception
      error = KeyError.new(@task, exception)
      error.detect(server)
      retry if error.try_again?
    end
  end
end
