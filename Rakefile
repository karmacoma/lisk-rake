require 'rubygems'

begin
  require 'byebug' if ENV['debug'] == 'true'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # Ignore LoadError
end

begin
  require 'sshkit'
  require 'sshkit/dsl'
  require 'io/console'
  $:.unshift File.dirname(__FILE__)
  $:.unshift File.dirname(__FILE__) + '/lib'
  Dir['lib/**/*.rb'].each { |file| require file }
rescue LoadError => exception
  puts "Error: #{exception}"
  exit 1
end

desc 'List configured servers'
task :list_servers do
  run_locally do
    info 'Listing available server(s)...'
    CryptiKit.config['servers'].values.each do |server|
      node = Node.new(server)
      info node.info
    end
    info '=> Done.'
  end
end

desc 'Add servers to config'
task :add_servers do
  run_locally do
    info 'Adding server(s)...'
    list = ServerList.new
    list.add_all(ENV['servers'])
    info 'Updating configuration...'
    list.save
    info '=> Done.'
  end
  Rake::Task['list_servers'].invoke
end

desc 'Remove servers from config'
task :remove_servers do
  run_locally do
    info 'Removing server(s)...'
    list = ServerList.new
    list.remove_all(ENV['servers'])
    info 'Updating configuration...'
    list.save
    info '=> Done.'
  end
  Rake::Task['list_servers'].invoke
end

desc 'Add your public ssh key'
task :add_key do
  each_server do |server, node, deps|
    deps.check_local('ssh', 'ssh-copy-id', 'ssh-keygen')

    run_locally do
      manager = KeyManager.new(self)
      unless test 'cat', CryptiKit.deploy_key then
        manager.gen_key
      end
      if test 'cat', CryptiKit.deploy_key then
        manager.add_key(server)
      end
    end
  end
end

desc 'Log into servers directly'
task :log_into do
  each_server do |server, node, deps|
    deps.check_local('ssh')

    run_locally do
      info "Logging into #{server}..."
      system("ssh #{CryptiKit.deploy_user_at_host(server)}")
      info '=> Done.'
    end
  end
end

desc 'Install dependencies'
task :install_deps do
  puts 'Installing dependencies...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'apt-get')

    info 'Updating package lists...'
    execute 'apt-get', 'update'
    info 'Installing packages...'
    execute 'apt-get', 'install', '-f', '--yes', CryptiKit.apt_dependencies
    info 'Adding nodejs repository...'
    execute 'curl', '-sL', 'https://deb.nodesource.com/setup', '|', 'bash', '-'
    info 'Purging conflicting packages...'
    execute 'apt-get', 'purge', '-f', '--yes', CryptiKit.apt_conflicts
    info 'Purging packages no longer required...'
    execute 'apt-get', 'autoremove', '--purge', '--yes'
    info 'Installing nodejs...'
    execute 'apt-get', 'install', '-f', '--yes', 'nodejs'
    info 'Installing forever...'
    execute 'npm', 'install', '-g', 'forever'
    info '=> Done.'
  end
end

desc 'Install crypti nodes'
task :install_nodes do
  puts 'Installing crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'npm', 'wget', 'unzip')

    info 'Stopping all processes...'
    execute 'forever', 'stopall', '||', ':'
    info 'Setting up...'
    execute 'rm', '-rf', CryptiKit.deploy_path
    execute 'mkdir', '-p', CryptiKit.deploy_path
    within CryptiKit.deploy_path do
      info 'Downloading crypti...'
      execute 'wget', CryptiKit.app_url
      info 'Installing crypti...'
      execute 'unzip', CryptiKit.zip_file
      info 'Cleaning up...'
      execute 'rm', CryptiKit.zip_file
    end
    within CryptiKit.install_path do
      info 'Installing node modules...'
      execute 'npm', 'install'
      info 'Downloading blockchain...'
      execute 'wget', CryptiKit.blockchain_url
      info 'Decompressing blockchain...'
      execute 'unzip', 'blockchain.db.zip'
      info 'Cleaning up...'
      execute 'rm', 'blockchain.db.zip'
      info 'Starting crypti node...'
      execute 'forever', 'start', 'app.js', '||', ':'
      info '=> Done.'
    end
  end
end

desc 'Install dependencies and crypti nodes'
task :install_all do
  Rake::Task['install_deps'].invoke
  Rake::Task['install_nodes'].invoke
end

desc 'Uninstall crypti nodes'
task :uninstall_nodes do
  puts 'Uninstalling crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    info 'Stopping all processes...'
    execute 'forever', 'stopall', '||', ':'
    info 'Removing crypti...'
    execute 'rm', '-rf', CryptiKit.deploy_path
    info '=> Done.'
  end
end

desc 'Start crypti nodes'
task :start_nodes do
  puts 'Starting crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    within CryptiKit.install_path do
      info 'Stopping all processes...'
      execute 'forever', 'stopall', '||', ':'
      info 'Starting crypti node...'
      execute 'forever', 'start', 'app.js', '||', ':'
      info '=> Done.'
    end
  end
end

desc 'Restart crypti nodes'
task :restart_nodes do
  puts 'Restarting crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    within CryptiKit.install_path do
      info 'Restarting crypti node...'
      execute 'forever', 'restart', 'app.js', '||', ':'
      info '=> Done.'
    end
  end
end

desc 'Rebuild crypti nodes (using new blockchain only)'
task :rebuild_nodes do
  puts 'Rebuilding crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'wget', 'crypti')

    within CryptiKit.install_path do
      info 'Stopping all processes...'
      execute 'forever', 'stopall', '||', ':'
      info 'Removing old blockchain...'
      execute 'rm', '-f', 'blockchain.db*'
      info 'Removing old log file...'
      execute 'rm', '-f', 'logs.log'
      info 'Downloading blockchain...'
      execute 'wget', CryptiKit.blockchain_url
      info 'Decompressing blockchain...'
      execute 'unzip', 'blockchain.db.zip'
      info 'Cleaning up...'
      execute 'rm', 'blockchain.db.zip'
      info 'Starting crypti node...'
      execute 'forever', 'start', 'app.js', '||', ':'
      info '=> Done.'
    end
  end
end

desc 'Stop crypti nodes'
task :stop_nodes do
  puts 'Stopping crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    within CryptiKit.install_path do
      info 'Stopping crypti node...'
      execute 'forever', 'stop', 'app.js', '||', ':'
      info '=> Done.'
    end
  end
end

desc 'Start forging on crypti nodes'
task :start_forging do
  puts 'Starting forging...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    node.get_passphrase do |passphrase|
      api = CryptiApi.new(self)
      api.post '/forgingApi/startForging', passphrase
      api.post '/api/unlock', passphrase do |json|
        manager = AccountManager.new(self, server)
        manager.add_account(json, passphrase)
      end
    end
  end

  Rake::Task['check_nodes'].invoke
end

desc 'Stop forging on crypti nodes'
task :stop_forging do
  puts 'Stopping forging...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    node.get_passphrase do |passphrase|
      api = CryptiApi.new(self)
      api.post '/forgingApi/stopForging', passphrase do |json|
        manager = AccountManager.new(self, server)
        manager.remove_account(json)
      end
    end
  end

  Rake::Task['check_nodes'].invoke
end

desc 'Check status of crypti nodes'
task :check_nodes do
  puts 'Checking nodes...'

  report = Report.new
  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    api = NodeApi.new(self)
    api.node_status(node) { |json| report[node.key] = json }
  end

  report.baddies = CryptiKit.baddies
  puts report.to_s
end

desc 'Withdraw surplus coinage from crypti nodes'
task :withdraw_surplus do
  puts 'Withdrawing surplus coinage...'

  account = Account.new
  exit unless account.get_address

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    Withdrawal.new(self) do |withdrawal|
      withdrawal.node    = node
      withdrawal.account = account
      withdrawal.withdraw
    end
  end
end
