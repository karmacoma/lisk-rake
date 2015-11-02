module CryptiKit
  class DebianInstaller
    def initialize(task)
      @task = task
    end

    def install
      @task.info 'Updating package lists...'
      @task.execute 'apt-get', 'update'
      @task.info 'Installing packages...'
      @task.execute 'apt-get', 'install', '-f', '--yes', 'build-essential', 'curl', 'python', 'wget', 'unzip', 'cron'
      @task.info 'Adding sqlite3 repository...'
      @task.execute 'curl', '-sL', 'http://downloads.cryptichain.me/setup_sqlite3', '|', 'bash', '-'
      @task.info 'Adding nodejs repository...'
      @task.execute 'curl', '-sL', 'https://deb.nodesource.com/setup_0.12', '|', 'bash', '-'
      @task.info 'Purging conflicting packages...'
      @task.execute 'apt-get', 'purge', '-f', '--yes', 'nodejs', 'nodejs-legacy', 'npm', 'sqlite3'
      @task.info 'Purging packages no longer required...'
      @task.execute 'apt-get', 'autoremove', '--purge', '--yes'
      @task.info 'Installing nodejs...'
      @task.execute 'apt-get', 'install', '-f', '--yes', 'nodejs', 'sqlite3'
      @task.info 'Installing forever...'
      @task.execute 'npm', 'install', '-g', 'forever'
      @task.info '=> Done.'
    end
  end
end
