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
    manager = CryptiKit::ServerManager.new(self)
    manager.list
  end
end

desc 'Add servers to config'
task :add_servers do
  run_locally do
    manager = CryptiKit::ServerManager.new(self)
    manager.add
  end
  Rake::Task['list_servers'].invoke
end

desc 'Remove servers from config'
task :remove_servers do
  run_locally do
    manager = CryptiKit::ServerManager.new(self)
    manager.remove
  end
  Rake::Task['list_servers'].invoke
end

desc 'Add your public ssh key'
task :add_key do
  each_server do |server, node, deps|
    deps.check_local('ssh', 'ssh-copy-id', 'ssh-keygen')

    run_locally do
      manager = CryptiKit::KeyManager.new(self)
      unless test 'cat', CryptiKit::Core.deploy_key then
        manager.gen_key
      end
      if test 'cat', CryptiKit::Core.deploy_key then
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
      manager = CryptiKit::ServerManager.new(self)
      manager.log_into(server)
    end
  end
end

desc 'Install dependencies'
task :install_deps do
  puts 'Installing dependencies...'

  on_each_server do |server, node, deps|
    installer = CryptiKit::ServerInstaller.new(self)
    installer.install(node, deps)
  end
end

desc 'Install crypti nodes'
task :install_nodes do
  puts 'Installing crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'npm', 'wget', 'unzip')

    installer = CryptiKit::NodeInstaller.new(self)
    installer.install
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

    installer = CryptiKit::NodeInstaller.new(self)
    installer.uninstall
  end
end

desc 'Clean logs on each server'
task :clean_logs do
  puts 'Cleaning logs...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'truncate', 'crypti')

    manager = CryptiKit::LogManager.new(self)
    manager.clean
  end
end

desc 'Download logs from each server'
task :download_logs do
  puts 'Downloading logs...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    manager = CryptiKit::LogManager.new(self)
    manager.download(node)
  end
end

desc 'Start crypti nodes'
task :start_nodes do
  puts 'Starting crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    manager = CryptiKit::NodeManager.new(self)
    manager.start
  end
end

desc 'Restart crypti nodes'
task :restart_nodes do
  puts 'Restarting crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    manager = CryptiKit::NodeManager.new(self)
    manager.restart
  end
end

desc 'Rebuild crypti nodes (using new blockchain only)'
task :rebuild_nodes do
  puts 'Rebuilding crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'wget', 'crypti')

    installer = CryptiKit::NodeInstaller.new(self)
    installer.rebuild
  end
end

desc 'Stop crypti nodes'
task :stop_nodes do
  puts 'Stopping crypti nodes...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    manager = CryptiKit::NodeManager.new(self)
    manager.stop
  end
end

desc 'Start forging on crypti nodes'
task :start_forging do
  puts 'Starting forging...'

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    node.get_passphrase do |passphrase|
      api = CryptiKit::Curl.new(self)
      api.post '/forgingApi/startForging', passphrase
      api.post '/api/unlock', passphrase do |json|
        manager = CryptiKit::AccountManager.new(self, server)
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
      api = CryptiKit::Curl.new(self)
      api.post '/forgingApi/stopForging', passphrase do |json|
        manager = CryptiKit::AccountManager.new(self, server)
        manager.remove_account(json)
      end
    end
  end

  Rake::Task['check_nodes'].invoke
end

desc 'Check status of crypti nodes'
task :check_nodes do
  puts 'Checking nodes...'

  report = CryptiKit::Report.new

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'forever', 'ps', 'crypti')

    api = CryptiKit::NodeApi.new(self)
    api.node_status(node) { |json| report[node.key] = json }
  end

  report.baddies = CryptiKit::Core.baddies
  puts report.to_s
  report.save
end

desc 'Withdraw surplus coinage from crypti nodes'
task :withdraw_surplus do
  puts 'Withdrawing surplus coinage...'

  account = CryptiKit::Account.new
  exit unless account.get_address

  on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    CryptiKit::Withdrawal.new(self) do |withdrawal|
      withdrawal.node    = node
      withdrawal.account = account
      withdrawal.withdraw
    end
  end
end
