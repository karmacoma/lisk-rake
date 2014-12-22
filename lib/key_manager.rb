module CryptiKit
  class KeyManager
    def initialize(task)
      @task = task
    end

    def gen_key
      @task.warn 'Could not find ssh key. Creating a new one...'
      system 'ssh-keygen -t rsa'
    end

    def add_key(server)
      @task.info "Adding public ssh key to: #{server}..."
      @task.execute 'ssh-copy-id', '-i', Core.deploy_key, "#{Core.deploy_user_at_host(server)}"
      @task.info '=> Done.'
    rescue Exception => exception
      error = KeyError.new(@task, exception)
      error.detect(server)
      retry if error.try_again?
    end
  end
end
