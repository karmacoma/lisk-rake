class AccountManager
  def initialize(task)
    @task = task
  end

  def key(server)
    servers = CryptiKit.config['servers']
    servers.key(server.to_s)
  end

  def account(json)
    json['address'] || json['account'] || json['error']
  end

  def add_account(json, server)
    if json.is_a?(Hash) and json['forging'] then
      @task.info "Adding account: #{account(json)}..."
      list = AccountList.new
      list[key(server)] = extract_account(json)
      list.save
      @task.info '=> Done.'
    end
  end

  def remove_account(json, server)
    if json.is_a?(Hash) and !json['forgingEnabled'] then
      @task.info "Removing account: #{account(json)}..."
      list = AccountList.new
      list.remove(key(server))
      list.save
      @task.info '=> Done.'
    end
  end

  private

  def extract_account(json)
    { 'address' => json['address'], 'public_key' => json['publickey'] }
  end
end
