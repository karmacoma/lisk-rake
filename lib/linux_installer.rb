module CryptiKit
  class LinuxInstaller
    def initialize(task)
      @task = task
    end

    def install(node, deps)
      insp = LinuxInspector.new(@task)
      insp.detect

      begin
        installer = Kernel.const_get("CryptiKit::#{insp.dist}Installer").new(@task)
        installer.install(node, deps)
      rescue NameError
        raise 'Unimplemented installation method.'
      end
    end
  end
end
