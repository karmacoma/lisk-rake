module CryptiKit
  class DependencyManager
    def initialize(task, node)
      @task = task
      @node = node
    end

    def check_local(*deps)
      check_dependencies(deps)
    end

    def check_remote(*deps)
      check_lisk_node(deps)
      check_dependencies(deps)
    end

    private

    def location
      unless @location.is_a?(Hash) then
        type      = @task.kind_of?(SSHKit::Backend::Local) ? :local : :remote
        name      = type == :remote ? "on server: #{@node.hostname}" : 'on local machine'
        @location = { type: type, name: name }
      else
        @location
      end
    end

    def check_dependencies(deps)
      @task.info "Checking #{location[:type]} dependencies..."

      deps.delete_if { |d| d == 'lisk' }.each do |dep|
        if @task.test('which', dep) then
          @task.info "=> Found: #{dep}."
        else
          raise "Missing dependency: '#{dep}' #{location[:name]}."
        end
      end
    end

    def check_lisk_node(deps)
      return unless deps.include?('lisk')
      @task.info 'Looking for lisk node...'

      if @task.test "[ -f #{@node.lisk_path + '/lisk.sh'} ];" then
        @task.info '=> Found.'
      else
        raise "Lisk node is not installed #{location[:name]}."
      end
    end

    def deploy_path?
      @task.test "[ -d #{@node.deploy_path} ];"
    end
  end
end
