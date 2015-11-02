module CryptiKit
  class ServerInstaller
    def initialize(task)
      @task = task
    end

    def install(node, deps)
      insp = ServerInspector.new(@task)
      insp.detect
      case insp.base
      when :debian then
        deps.check_remote(node, 'apt-get')
        installer = DebianInstaller.new(@task)
        installer.install
      end
    end
  end
end
