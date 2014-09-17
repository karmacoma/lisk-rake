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
require 'lib/crypti_kit'
require 'lib/crypti_api'
require 'lib/server_list'
require 'lib/task_kit'

kit = CryptiKit.new('config.yml')

desc 'List available servers'
task :list_servers do
  run_locally do
    info 'Listing available server(s)...'
    kit.config['servers'].values.each do |server|
      info kit.server_info(server)
    end
    info 'Done.'
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
    info 'Done.'
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
    info 'Done.'
  end
  Rake::Task['list_servers'].invoke
end

desc 'Add your public ssh key'
task :add_key do
  kit.servers(ENV['servers']).each do |server|
    run_locally do
      task_kit = TaskKit.new(self, kit)
      unless test 'cat', kit.deploy_key then
        task_kit.gen_key
      end
      if test 'cat', kit.deploy_key and test 'which', 'ssh-copy-id' then
        task_kit.add_key(server)
      end
    end
  end
end

desc 'Log into servers'
task :log_into do
  kit.servers(ENV['servers']).each do |server|
    run_locally do
      info "Logging into #{server}..."
      system("ssh #{kit.deploy_user_at_host(server)}")
      info 'Done.'
    end
  end
end

desc 'Install dependencies'
task :install_deps do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
    as kit.deploy_user do
      info 'Adding repository...'
      execute 'curl', '-sL', 'https://deb.nodesource.com/setup', '|', 'bash', '-'
      info 'Installing apt dependencies...'
      execute 'apt-get', 'install', '-f', '--yes', kit.apt_dependencies
      info 'Installing npm dependencies...'
      execute 'npm', 'install', '-g', kit.npm_dependencies
      info 'Done.'
    end
  end
end

desc 'Install crypti nodes'
task :install_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
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
        info 'Starting crypti node...'
        execute 'forever', 'start', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Uninstall crypti nodes'
task :uninstall_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
    as kit.deploy_user do
      info 'Stopping all processes...'
      execute 'forever', 'stopall', '||', ':'
      info 'Removing crypti...'
      execute 'rm', '-rf', kit.deploy_path
      info 'Done.'
    end
  end
end

desc 'Start crypti nodes'
task :start_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
    as kit.deploy_user do
      within kit.install_path do
        info 'Starting crypti node...'
        execute 'forever', 'start', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Restart crypti nodes'
task :restart_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
    as kit.deploy_user do
      within kit.install_path do
        info 'Restarting crypti node...'
        execute 'forever', 'restart', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Rebuild crypti nodes (using new blockchain only)'
task :rebuild_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
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
        info 'Starting crypti node...'
        execute 'forever', 'start', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Stop crypti nodes'
task :stop_nodes do
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do
    as kit.deploy_user do
      within kit.install_path do
        info 'Stopping crypti node...'
        execute 'forever', 'stop', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Start forging on crypti nodes'
task :start_forging do
  puts 'Starting forging...'
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do |server|
    api = CryptiApi.new(self)
    api.silent_post '/forgingApi/startForging', kit.get_passphrase(server)
  end
  Rake::Task['get_forging'].invoke
end

desc 'Stop forging on crypti nodes'
task :stop_forging do
  puts 'Stopping forging...'
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do |server|
    api = CryptiApi.new(self)
    api.silent_post '/forgingApi/stopForging', kit.get_passphrase(server)
  end
  Rake::Task['get_forging'].invoke
end

desc 'Get loading status'
task :get_loading do
  puts 'Getting loading status...'
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do |server|
    api  = CryptiApi.new(self)
    body = api.get '/api/getLoading'
    info kit.server_info(server) + ": #{body}"
  end
end

desc 'Get forging status'
task :get_forging do
  puts 'Getting forging status...'
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do |server|
    api  = CryptiApi.new(self)
    body = api.get '/forgingApi/getForgingInfo'
    info kit.server_info(server) + ": #{body}"
  end
end
