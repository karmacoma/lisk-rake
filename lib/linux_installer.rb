module LiskRake
  class LinuxInstaller
    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      insp = LinuxInspector.new(@task)
      insp.detect

      begin
        installer = Kernel.const_get("LiskRake::#{insp.dist}Installer").new(@task, @node, @deps)
      rescue NameError
        raise 'Unimplemented installation method.'
      end

      installer.install
    end
  end
end
