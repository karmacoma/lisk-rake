module CryptiKit
  class UbuntuInstaller
    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      @deps.check_remote('sudo', 'apt-get')

      @task.info 'Updating package lists...'
      @task.execute 'sudo', '-S', 'apt-get', 'update', interaction_handler: SudoHandler.new
      @task.info 'Installing packages...'
      @task.execute 'sudo', '-S', 'apt-get', 'install', '-f', '--yes', 'bash', 'curl', 'wget', 'unzip', interaction_handler: SudoHandler.new
      @task.info '=> Done.'
    end
  end
end
