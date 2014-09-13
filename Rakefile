require 'rubygems'
require 'sshkit'
require 'sshkit/dsl'
require 'open-uri'
require 'json'

$:.unshift File.dirname(__FILE__)
require 'lib/cryptikit'

kit = CryptiKit.new(YAML.load_file('config.yml'))

desc 'Add your public ssh key.'
task :add_key do
  kit.servers.each do |server|
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

desc 'Install dependencies.'
task :install_deps do
  on kit.servers, in: :sequence, wait: 5 do
    as kit.deploy_user do
      info 'Adding repository...'
      execute 'curl', '-sL', 'https://deb.nodesource.com/setup', '|', 'bash', '-'
      info 'Installing apt dependencies...'
      execute 'apt-get', 'install', '-f', kit.apt_dependencies
      info 'Installing npm dependencies...'
      execute 'npm', 'install', '-g', kit.npm_dependencies
      info 'Done.'
    end
  end
end

desc 'Install crypti nodes.'
task :install_nodes do
  on kit.servers, in: :sequence, wait: 5 do
    info 'Stopping all processes...'
    execute 'forever', 'stopall', '||', ':'
    as kit.deploy_user do
      info 'Setting up...'
      execute 'rm', '-rf', kit.deploy_path
      execute 'mkdir', '-p', kit.deploy_path
      within kit.deploy_path do
        info 'Downloading crypti...'
        execute 'wget', kit.app_url
        info 'Downloading blockchain...'
        execute 'wget', kit.blockchain_url
        info 'Installing crypti...'
        execute 'unzip', kit.zip_file
        info 'Cleaning up...'
        execute 'rm', kit.zip_file
      end
      within kit.install_path do
        info 'Installing node modules...'
        execute 'npm', 'install'
        info 'Installing blockchain...'
        execute 'mv', '../blockchain.db?dl=1', 'blockchain.db'
        info 'Done.'
      end
    end
  end
end

desc 'Uninstall crypti nodes.'
task :uninstall_nodes do
  on kit.servers, in: :sequence, wait: 5 do
    info 'Stopping all processes...'
    execute 'forever', 'stopall', '||', ':'
    as kit.deploy_user do
      info 'Removing crypti...'
      execute 'rm', '-rf', kit.deploy_path
      info 'Done.'
    end
  end
end

desc 'Start crypti nodes.'
task :start_nodes do
  on kit.servers, in: :sequence, wait: 5 do
    as kit.deploy_user do
      within kit.install_path do
        info 'Starting crypti node...'
        execute 'forever', 'start', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Restart crypti nodes.'
task :restart_nodes do
  on kit.servers, in: :sequence, wait: 5 do
    as kit.deploy_user do
      within kit.install_path do
        info 'Restarting crypti node...'
        execute 'forever', 'restart', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Stop crypti nodes.'
task :stop_nodes do
  on kit.servers, in: :sequence, wait: 5 do
    as kit.deploy_user do
      within kit.install_path do
        info 'Stopping crypti node...'
        execute 'forever', 'stop', 'app.js', '||', ':'
        info 'Done.'
      end
    end
  end
end

desc 'Get loading status.'
task :get_loading do
  puts 'Getting loading status...'
  kit.servers.each do |server|
    begin
      body = open("http://#{server}:6040/api/getLoading").read
      puts "Node: #{server}: #{JSON.parse(body)}"
    rescue => exception
      puts "Node: #{server}: #{exception}"
    end
  end
end
