class DependencyManager
  def initialize(task, kit)
    @task = task
    @kit  = kit
  end

  def check_local(deps)
    check_dependencies(deps)
  end

  def check_remote(server, *deps)
    check_dependencies(deps.to_a, server)
  end

  private

  def check_dependencies(deps, server = nil)
    deps.each do |dep|
      if !@task.test('which', dep) then
        location = server ? :remote : :local
        @task.info @kit.server_info(server) if server
        @task.info "Can not continue with task..."
        @task.info "Missing dependency: '#{dep}' on #{location} system."
        return false
      else
        return true
      end
    end
  end
end