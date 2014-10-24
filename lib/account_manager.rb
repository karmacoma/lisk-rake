class AccountManager
  def initialize(task, server)
    @task   = task
    @server = server
    @list   = AccountList.new
  end

  def add_account(json)
    if json.is_a?(Hash) and json['forging'] then
      @task.info "Adding account: #{account(json)}..."
      @list[key] = extract_account(json)
      @list.save
      @task.info '=> Done.'
    end
  end

  def remove_account(json)
    if json.is_a?(Hash) and !json['forgingEnabled'] then
      @task.info "Removing account: #{account(json)}..."
      @list.remove(key)
      @list.save
      @task.info '=> Done.'
    end
  end

  private

  def key
    CryptiKit.config['servers'].key(@server.to_s)
  end

  def account(json)
    json['address'] || json['account'] || json['error']
  end

  def extract_account(json)
    { 'address' => json['address'], 'public_key' => json['publickey'] }
  end
end
