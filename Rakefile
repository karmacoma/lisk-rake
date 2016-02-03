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

desc 'Edit servers within config'
task :edit_servers do
  run_locally do
    manager = CryptiKit::ServerManager.new(self)
    manager.edit
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
  each_server do |node, deps|
    deps.check_local('ssh', 'ssh-copy-id', 'ssh-keygen')

    run_locally do
      manager = CryptiKit::KeyManager.new(self)
      manager.add(node.server)
    end
  end
end

desc 'Log into servers directly'
task :log_into do
  each_server do |node, deps|
    deps.check_local('ssh')

    run_locally do
      manager = CryptiKit::ServerManager.new(self)
      manager.log_into(node.server)
    end
  end
end

desc 'Install dependencies'
task :install_deps do
  puts 'Installing dependencies...'

  on_each_server do |node, deps|
    installer = CryptiKit::ServerInstaller.new(self, node, deps)
    installer.install
  end
end

desc 'Install lisk nodes'
task :install_nodes do
  puts 'Installing lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'unzip')

    installer = CryptiKit::NodeInstaller.new(self, node)
    installer.install
  end
end

desc 'Install dependencies and lisk nodes'
task :install_all do
  Rake::Task['install_deps'].invoke
  Rake::Task['install_nodes'].invoke
end

desc 'Uninstall lisk nodes'
task :uninstall_nodes do
  puts 'Uninstalling lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    installer = CryptiKit::NodeInstaller.new(self, node)
    installer.uninstall
  end
end

desc 'Clean logs on each server'
task :clean_logs do
  puts 'Cleaning logs...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    manager = CryptiKit::LogManager.new(self, node)
    manager.clean
  end
end

desc 'Download logs from each server'
task :download_logs do
  puts 'Downloading logs...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    manager = CryptiKit::LogManager.new(self, node)
    manager.download
  end
end

desc 'Start lisk nodes'
task :start_nodes do
  puts 'Starting lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    manager = CryptiKit::NodeManager.new(self, node)
    manager.start
  end
end

desc 'Restart lisk nodes'
task :restart_nodes do
  puts 'Restarting lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    manager = CryptiKit::NodeManager.new(self, node)
    manager.restart
  end
end

desc 'Rebuild lisk nodes (using new blockchain only)'
task :rebuild_nodes do
  puts 'Rebuilding lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'lisk')

    installer = CryptiKit::NodeInstaller.new(self, node)
    installer.rebuild
  end
end

desc 'Reinstall lisk nodes (keeping blockchain and config intact)'
task :reinstall_nodes do
  puts 'Reinstalling lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'lisk')

    installer = CryptiKit::NodeInstaller.new(self, node)
    installer.reinstall
  end
end

desc 'Stop lisk nodes'
task :stop_nodes do
  puts 'Stopping lisk nodes...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'lisk')

    manager = CryptiKit::NodeManager.new(self, node)
    manager.stop
  end
end

desc 'Start forging on lisk nodes'
task :start_forging do
  puts 'Starting forging...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'lisk')

    manager = CryptiKit::ForgingManager.new(self, node)
    manager.start
  end

  Rake::Task['check_nodes'].invoke
end

desc 'Stop forging on lisk nodes'
task :stop_forging do
  puts 'Stopping forging...'

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'lisk')

    manager = CryptiKit::ForgingManager.new(self, node)
    manager.stop
  end

  Rake::Task['check_nodes'].invoke
end

desc 'Check status of lisk nodes'
task :check_nodes do
  puts 'Checking nodes...'

  CryptiKit::Report.run do |report|
    on_each_server do |node, deps|
      deps.check_remote('bash', 'curl', 'lisk')

      api = CryptiKit::NodeInspector.new(self, node)
      api.node_status { |json| report[node.key] = json }
    end
  end
end

desc 'Withdraw funds from lisk nodes'
task :withdraw_funds do
  puts 'Withdrawing funds...'

  recipient = CryptiKit::Recipient.new
  exit unless recipient.get_address

  on_each_server do |node, deps|
    deps.check_remote('bash', 'curl', 'lisk')

    CryptiKit::Withdrawal.withdraw(self, node, recipient)
  end
end
