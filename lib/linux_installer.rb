module CryptiKit
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
        installer = Kernel.const_get("CryptiKit::#{insp.dist}Installer").new(@task, @node, @deps)
        installer.install
      rescue NameError
        raise 'Unimplemented installation method.'
      end
    end
  end
end
