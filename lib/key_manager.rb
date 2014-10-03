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
    @task.execute 'ssh-copy-id', '-i', CryptiKit.deploy_key, "#{CryptiKit.deploy_user_at_host(server)}"
    @task.info '=> Done.'
  rescue Exception => exception
    case exception.to_s
    when /Your password has expired/ then
      @task.warn 'Password change required. Please login and change password...'
      system "ssh -t #{CryptiKit.deploy_user_at_host(server)} exit"
      @task.info 'Trying to add public ssh key again...'
      retry
    else
      raise exception
    end
  end
end
