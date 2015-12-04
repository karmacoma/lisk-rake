module CryptiKit
  class UbuntuInstaller
    def initialize(task)
      @task = task
    end

    def install(node, deps)
      deps.check_remote(node, 'sudo', 'apt-get')

      @task.info 'Updating package lists...'
      @task.execute 'sudo', 'apt-get', 'update'
      @task.info 'Installing packages...'
      @task.execute 'sudo', 'apt-get', 'install', '-f', '--yes', 'bash', 'curl', 'wget', 'unzip'
      @task.info '=> Done.'
    end
  end
end
