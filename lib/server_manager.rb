class ServerManager
  def initialize(task)
    @task = task
    @list = ServerList.new
  end

  def list
    @task.info 'Listing available server(s)...'
    @list.values.each do |server|
      node = Node.new(server)
      @task.info node.info
    end
    @task.info '=> Done.'
  end

  def add
    @task.info 'Adding server(s)...'
    @list.add_all(ENV['servers'])
    @task.info 'Updating configuration...'
    @list.save
    @task.info '=> Done.'
  end

  def remove
    @task.info 'Removing server(s)...'
    @list.remove_all(ENV['servers'])
    @task.info 'Updating configuration...'
    @list.save
    @task.info 'Forgetting server(s)...'
    @list.forget_all(ENV['servers'])
    @task.info '=> Done.'
  end
end
