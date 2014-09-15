require 'rubygems'
require 'io/console'
require 'sshkit'
require 'sshkit/dsl'

$:.unshift File.dirname(__FILE__)
require 'lib/cryptikit'
require 'lib/cryptiapi'

kit = CryptiKit.new(YAML.load_file('config.yml'))

desc 'Add your public ssh key'
task :add_key do
  kit.servers(ENV['servers']).each do |server|
    run_locally do
      unless test 'cat', kit.deploy_key then
        run_locally do
          info 'Could not find ssh key. Creating a new one...'
          system 'ssh-keygen -t rsa'
        end
      end
      if test 'cat', kit.deploy_key and test 'which', 'ssh-copy-id' then
        info 'Adding public ssh key to: ' + server + '...'
        execute 'ssh-copy-id', '-i', kit.deploy_key, "#{kit.deploy_user}@#{server}"
      end
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
        info 'Downloading blockchain...'
        execute 'wget', kit.blockchain_url
        info 'Removing old log file...'
        execute 'rm', '-f', 'logs.log'
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
    info "Node: #{server}: " + body.to_s
  end
end

desc 'Get forging status'
task :get_forging do
  puts 'Getting forging status...'
  on kit.servers(ENV['servers']), in: :sequence, wait: kit.server_delay do |server|
    api  = CryptiApi.new(self)
    body = api.get '/forgingApi/getForgingInfo'
    info "Node: #{server}: " + body.to_s
  end
end
