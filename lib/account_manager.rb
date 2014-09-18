class AccountManager
  def initialize(task, kit)
    @task = task
    @kit  = kit
  end

  def account(json)
    json['address'] || json['account'] || json['error']
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
end