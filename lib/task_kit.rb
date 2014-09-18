class TaskKit
  def initialize(task, kit)
    @task = task
    @kit  = kit
  end

  def gen_key
    @task.info 'Could not find ssh key. Creating a new one...'
    system 'ssh-keygen -t rsa'
  end

  def add_key(server)
    @task.info "Adding public ssh key to: #{server}..."
    @task.execute 'ssh-copy-id', '-i', @kit.deploy_key, "#{@kit.deploy_user_at_host(server)}"
  rescue Exception => exception
    case exception.to_s
    when /Your password has expired/ then
      @task.info 'Password change required. Please login and change password...'
      system "ssh -t #{@kit.deploy_user_at_host(server)} exit"
      @task.info 'Trying to add public ssh key again...'
      retry
    else
      raise exception
    end
  end

  def add_account(json, server)
    if json.is_a?(Hash) and json['forging'] then
      @task.info "Adding account: #{account(json)}..."
      key  = @kit.server_key(server)
      list = AccountList.new(@kit.config)
      list[key] = json['address']
      list.save
      @task.info 'Done.'
    end
  end

  def remove_account(json, server)
    if json.is_a?(Hash) and !json['forgingEnabled'] then
      @task.info "Removing account: #{account(json)}..."
      key  = @kit.server_key(server)
      list = AccountList.new(@kit.config)
      list.remove(key)
      list.save
      @task.info 'Done.'
    end
  end

  def account(json)
    json['address'] || json['account'] || json['error']
  end
end
