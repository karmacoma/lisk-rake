require 'rubygems'
require 'io/console'
require 'sshkit'
require 'sshkit/dsl'
require 'json'
require 'yaml'

if ENV['debug'] == 'true' then
  require 'byebug'
end

$:.unshift File.dirname(__FILE__)

require 'lib/crypti_netssh'
require 'lib/crypti_report'
require 'lib/crypti_node'
require 'lib/crypti_kit'
require 'lib/crypti_api'

require 'lib/list'
require 'lib/server_list'
require 'lib/account_list'

require 'lib/key_manager'
require 'lib/account_manager'
require 'lib/dependency_manager'
require 'lib/node_status'

require 'lib/colorize'
include Colorize

kit = CryptiKit.new('config.yml')

desc 'List configured servers'
task :list_servers do
  run_locally do
    info 'Listing available server(s)...'
    kit.config['servers'].values.each do |server|
      node = CryptiNode.new(kit.config, server)
      info node.info
    end
    info '=> Done.'
  end
end

desc 'Add servers to config'
task :add_servers do
  run_locally do
    info 'Adding server(s)...'
    list = ServerList.new(kit.config)
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
    list = ServerList.new(kit.config)
    list.remove_all(ENV['servers'])
    info 'Updating configuration...'
    list.save
    info '=> Done.'
  end
  Rake::Task['list_servers'].invoke
end

desc 'Add your public ssh key'
task :add_key do
  kit.each_server do |server, node, deps|
    deps.check_local('ssh', 'ssh-copy-id', 'ssh-keygen')

    run_locally do
      manager = KeyManager.new(self, kit)
      unless test 'cat', kit.deploy_key then
        manager.gen_key
      end
      if test 'cat', kit.deploy_key then
        manager.add_key(server)
      end
    end
  end
end

desc 'Log into servers directly'
task :log_into do
  kit.each_server do |server, node, deps|
    deps.check_local('ssh')

    run_locally do
      info "Logging into #{server}..."
      system("ssh #{kit.deploy_user_at_host(server)}")
      info '=> Done.'
    end
  end
end

desc 'Install dependencies'
task :install_deps do
  puts 'Installing dependencies...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'apt-get', 'curl')

    as kit.deploy_user do
      info 'Adding repository...'
      execute 'curl', '-sL', 'https://deb.nodesource.com/setup', '|', 'bash', '-'
      info 'Purging conflicting packages...'
      execute 'apt-get', 'purge', '-f', '--yes', kit.apt_conflicts
      info 'Purging packages no longer required...'
      execute 'apt-get', 'autoremove', '--purge', '--yes'
      info 'Installing apt dependencies...'
      execute 'apt-get', 'install', '-f', '--yes', kit.apt_dependencies
      info 'Installing npm dependencies...'
      execute 'npm', 'install', '-g', kit.npm_dependencies
      info '=> Done.'
    end
  end
end

desc 'Install crypti nodes'
task :install_nodes do
  puts 'Installing crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'npm', 'wget', 'unzip')

    as kit.deploy_user do
      info 'Stopping all processes...'
      execute 'forever', 'stopall', '||', ':'
      info 'Setting up...'
      execute 'rm', '-rf', kit.deploy_path
      execute 'mkdir', '-p', kit.deploy_path
      within kit.deploy_path do
        info 'Downloading crypti...'
        execute 'wget', kit.app_url
        info 'Installing crypti...'
        execute 'unzip', kit.zip_file
        info 'Cleaning up...'
        execute 'rm', kit.zip_file
      end
      within kit.install_path do
        info 'Installing node modules...'
        execute 'npm', 'install'
        info 'Downloading blockchain...'
        execute 'wget', kit.blockchain_url
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
end

desc 'Uninstall crypti nodes'
task :uninstall_nodes do
  puts 'Uninstalling crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    as kit.deploy_user do
      info 'Stopping all processes...'
      execute 'forever', 'stopall', '||', ':'
      info 'Removing crypti...'
      execute 'rm', '-rf', kit.deploy_path
      info '=> Done.'
    end
  end
end

desc 'Start crypti nodes'
task :start_nodes do
  puts 'Starting crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    as kit.deploy_user do
      within kit.install_path do
        info 'Stopping all processes...'
        execute 'forever', 'stopall', '||', ':'
        info 'Starting crypti node...'
        execute 'forever', 'start', 'app.js', '||', ':'
        info '=> Done.'
      end
    end
  end
end

desc 'Restart crypti nodes'
task :restart_nodes do
  puts 'Restarting crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    as kit.deploy_user do
      within kit.install_path do
        info 'Restarting crypti node...'
        execute 'forever', 'restart', 'app.js', '||', ':'
        info '=> Done.'
      end
    end
  end
end

desc 'Rebuild crypti nodes (using new blockchain only)'
task :rebuild_nodes do
  puts 'Rebuilding crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'wget', 'crypti')

    as kit.deploy_user do
      within kit.install_path do
        info 'Stopping all processes...'
        execute 'forever', 'stopall', '||', ':'
        info 'Removing old blockchain...'
        execute 'rm', '-f', 'blockchain.db*'
        info 'Removing old log file...'
        execute 'rm', '-f', 'logs.log'
        info 'Downloading blockchain...'
        execute 'wget', kit.blockchain_url
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
end

desc 'Stop crypti nodes'
task :stop_nodes do
  puts 'Stopping crypti nodes...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'forever', 'crypti')

    as kit.deploy_user do
      within kit.install_path do
        info 'Stopping crypti node...'
        execute 'forever', 'stop', 'app.js', '||', ':'
        info '=> Done.'
      end
    end
  end
end

desc 'Start forging on crypti nodes'
task :start_forging do
  puts 'Starting forging...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    node.get_passphrase do |passphrase|
      api = CryptiApi.new(self)
      api.post '/forgingApi/startForging', passphrase
      api.post '/api/unlock', passphrase do |json|
        manager = AccountManager.new(self, kit)
        manager.add_account(json, server)
      end
    end
  end
  Rake::Task['check_nodes'].invoke
end

desc 'Stop forging on crypti nodes'
task :stop_forging do
  puts 'Stopping forging...'

  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    node.get_passphrase do |passphrase|
      api = CryptiApi.new(self)
      api.post '/forgingApi/stopForging', passphrase do |json|
        manager = AccountManager.new(self, kit)
        manager.remove_account(json, server)
      end
    end
  end
  Rake::Task['check_nodes'].invoke
end

desc 'Check status of crypti nodes'
task :check_nodes do
  puts 'Checking nodes...'

  report = CryptiReport.new(kit.config)
  kit.on_each_server do |server, node, deps|
    deps.check_remote(node, 'curl', 'crypti')

    api = CryptiApi.new(self)
    api.node_status(node) { |json| report[node.key] = json }
  end
  report.baddies = kit.baddies
  puts report.to_s
end
