module CryptiKit
  class DependencyManager
    def initialize(task)
      @task = task
    end

    def check_local(*deps)
      check_dependencies(deps)
    end

    def check_remote(node, *deps)
      check_crypti_node(deps, node)
      check_dependencies(deps, node)
    end

    private

    def location(node)
      unless @location.is_a?(Hash) then
        type      = node ? :remote : :local
        name      = type == :remote ? "on server: #{node.server}" : 'on local machine'
        @location = { type: type, name: name }
      else
        @location
      end
    end

    def check_dependencies(deps, node = nil)
      @task.info "Checking #{location(node)[:type]} dependencies..."

      deps.delete_if { |d| d == 'crypti' }.each do |dep|
        if @task.test('which', dep) then
          @task.info "=> Found: #{dep}."
        else
          raise "Missing dependency: '#{dep}' #{location(node)[:name]}."
        end
      end
    end

    def check_crypti_node(deps, node)
      return unless deps.include?('crypti')
      @task.info 'Looking for crypti node...'

      if @task.test "[ -f #{Core.install_path + '/app.js'} ];" then
        @task.info '=> Found.'
      elsif versioned_install? then
        @task.info '=> Done.'
      else
        raise "Crypti node is not installed #{location(node)[:name]}."
      end
    end

    def deploy_path?
      @task.test "[ -d #{Core.deploy_path} ];"
    end

    def versioned_install?
      unless deploy_path? then
        return false
      end
      @task.within Core.deploy_path do
        ls = @task.capture 'ls', '-1d', '*/'

        if app_version = ls.to_s.split(/\n/).last then
          return move_versioned_install([Core.deploy_path, '/', app_version].join)
        else
          return false
        end
      end
    end

    def move_versioned_install(path)
      if @task.test "[ -f #{path + '/app.js'} ];" then
        @task.warn 'Moving versioned installation...'
        @task.execute 'mv', '-f', path, Core.install_path
        return true
      else
        return false
      end
    end
  end
end
