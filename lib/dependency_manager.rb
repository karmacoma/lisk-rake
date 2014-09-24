class DependencyManager
  def initialize(task, kit)
    @task = task
    @kit  = kit
  end

  def check_local(*deps)
    check_dependencies(deps)
  end

  def check_remote(server, *deps)
    check_crypti_node(deps, server) and check_dependencies(deps, server)
  end

  private

  def check_dependencies(deps, server = nil)
    location = server ? :remote : :local
    @task.info "Checking #{location} dependencies..."
    deps.delete_if { |d| d == 'crypti' }.each do |dep|
      if !@task.test('which', dep) then
        @task.info @kit.server_info(server) if server
        @task.error '=> Can not continue with task...'
        @task.error "=> Missing dependency: '#{dep}' on #{location} system."
        return false
      else
        @task.info '=> Done.'
        return true
      end
    end
  end

  def check_crypti_node(deps, server)
    return true unless deps.include?('crypti')
    @task.info 'Looking for crypti node...'
    if @task.test "[ -f #{@kit.install_path + '/app.js'} ];" then
      @task.info '=> Found.'
      return true
    else
      @task.error '=> Not Found.'
      @task.error "=> Please run the command: 'rake install_nodes servers=#{server.key}' and try again."
      return false
    end
  end
end
