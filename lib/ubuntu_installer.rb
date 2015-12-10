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
      @task.execute 'sudo', 'apt-get', 'update'
      @task.info 'Installing packages...'
      @task.execute 'sudo', 'apt-get', 'install', '-f', '--yes', 'bash', 'curl', 'wget', 'unzip'
      @task.info '=> Done.'
    end
  end
end
