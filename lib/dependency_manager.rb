class DependencyManager
  def initialize(task, kit)
    @task = task
    @kit  = kit
  end

  def check_local(*deps)
    check_dependencies(deps)
  end

  def check_remote(node, *deps)
    check_crypti_node(deps, node) and check_dependencies(deps, node)
  end

  def location(node)
    unless @location.is_a?(Hash) then
      type      = node ? :remote : :local
      name      = type == :remote ? "on server: #{node.server}" : 'on local machine'
      @location = { type: type, name: name }
    else
      @location
    end
  end

  private

  def check_dependencies(deps, node = nil)
    @task.info "Checking #{location(node)[:type]} dependencies..."
    deps.delete_if { |d| d == 'crypti' }.each do |dep|
      if !@task.test('which', dep) then
        raise "Missing dependency: '#{dep}' #{location(node)[:name]}."
      else
        @task.info '=> Done.'
      end
    end
  end

  def check_crypti_node(deps, node)
    return unless deps.include?('crypti')
    @task.info 'Looking for crypti node...'
    if @task.test "[ -f #{@kit.install_path + '/app.js'} ];" then
      @task.info '=> Found.'
    else
      raise "Crypti node is not installed #{location(node)[:name]}."
    end
  end
end
