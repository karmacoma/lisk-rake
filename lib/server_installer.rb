module LiskRake
  class ServerInstaller
    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      insp = ServerInspector.new(@task)
      insp.detect

      begin
        installer = Kernel.const_get("LiskRake::#{insp.os}Installer").new(@task, @node, @deps)
      rescue NameError
        raise 'Unimplemented installation method.'
      end

      @task.with path: '/usr/local/bin:$PATH' do
        installer.install
      end
    end
  end
end
