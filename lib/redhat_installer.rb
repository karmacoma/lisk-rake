module CryptiKit
  class RedhatInstaller
    def initialize(task)
      @task = task
    end

    def install
      @task.info 'Updating package lists...'
      @task.execute 'yum', 'clean', 'expire-cache'
      @task.info 'Installing packages...'
      @task.execute 'yum', 'install', '-y', 'gcc-c++', 'make', 'curl', 'python', 'sqlite', 'wget', 'unzip'
      @task.info 'Adding nodejs repository...'
      @task.execute 'curl', '-sL', 'https://rpm.nodesource.com/setup', '|', 'bash', '-'
      @task.info 'Installing nodejs...'
      @task.execute 'yum', 'install', '-y', 'nodejs'
      @task.info 'Installing forever...'
      @task.execute 'npm', 'install', '-g', 'forever'
      @task.info '=> Done.'
    end
  end
end
