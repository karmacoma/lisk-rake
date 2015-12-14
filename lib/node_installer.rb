module CryptiKit
  class NodeInstaller
    def initialize(task, node)
      @task    = task
      @node    = node
      @manager = NodeManager.new(@task, node)
    end

    def install
      @insp = ServerInspector.new(@task)
      @insp.detect

      Core.task do
        @manager.stop
        remove_deploy_path
        remove_accounts
        make_deploy_path
        @task.within @node.deploy_path do
          download_crypti
          install_crypti
        end
        @manager.start(true)
      end
    end

    def rebuild
      Core.task do
        @manager.stop
        @task.within @node.crypti_path do
          remove_blockchain
        end
        @manager.start
      end
    end

    def reinstall
      @insp = ServerInspector.new(@task)
      @insp.detect

      Core.task do
        @manager.stop
        @task.within @node.crypti_path do
          save_blockchain
        end
        ConfigMigrator.migrate(@task, @node) do
          remove_crypti_path
          @task.within @node.deploy_path do
            download_crypti
            install_crypti
          end
        end
        @manager.start(true)
      end
    end

    def uninstall
      Core.task do
        @manager.stop
        remove_deploy_path
        remove_accounts
        @task.info '=> Done.'
      end
    end

    private

    def remove_deploy_path
      @task.info 'Removing crypti...'
      @task.execute 'rm', '-rf', @node.deploy_path
    end

    def remove_accounts
      if @node.accounts.any? then
        @task.info 'Removing accounts...'
        AccountList.remove_all(@node)
      end
    end

    def remove_crypti_path
      @task.info 'Removing crypti...'
      @task.execute 'rm', '-rf', @node.crypti_path
    end

    def make_deploy_path
      @task.info 'Making deploy path...'
      @task.execute 'mkdir', '-p', @node.deploy_path
    end

    def app_url
      @app_url ||= "#{Core.download_url}#{zip_file}"
    end

    def app_path
      @app_path ||= "crypti-#{@insp.os}-#{@insp.arch}"
    end

    def zip_file
      @zip_file ||= "#{app_path}.zip"
    end

    def download_crypti
      @task.info 'Downloading crypti...'
      @task.execute 'curl', '-o', zip_file, app_url
    end

    def install_crypti
      @task.info 'Installing crypti...'
      @task.execute 'unzip', '-u', zip_file
      @task.execute 'mv', '-f', '$(ls -d * | head -1)', @node.crypti_path
      @task.info 'Cleaning up...'
      @task.execute 'rm', '-f', zip_file
    end

    def save_blockchain
      if @task.test '-f', 'blockchain.db' then
        @task.info 'Saving blockchain...'
        @task.execute 'cp', '-f', 'blockchain.db', '../blockchain.db.bak'
      end
    end

    def restore_blockchain
      if @task.test '-f', 'blockchain.db.bak' then
        @task.info 'Restoring blockchain...'
        @task.execute 'cp', '-f', '../blockchain.db.bak', 'blockchain.db'
      end
    end

    def remove_blockchain
      @task.info 'Removing blockchain...'
      @task.execute 'rm', '-f', 'blockchain.db*'
    end
  end
end
