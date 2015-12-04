module CryptiKit
  class NodeInstaller
    def initialize(task)
      @task    = task
      @manager = NodeManager.new(@task)
    end

    def install
      @insp = ServerInspector.new(@task)
      @insp.detect

      @manager.stop
      remove_deploy_path
      make_deploy_path
      @task.within Core.deploy_path do
        download_crypti
        install_crypti
      end
      @manager.start(true)
    end

    def rebuild
      @manager.stop
      @task.within Core.install_path do
        remove_blockchain
      end
      @manager.start
    end

    def reinstall
      @insp = ServerInspector.new(@task)
      @insp.detect

      @manager.stop
      @task.within Core.install_path do
        save_blockchain
      end
      remove_install_path
      @task.within Core.deploy_path do
        download_crypti
        install_crypti
      end
      @manager.start(true)
    end

    def uninstall
      @manager.stop
      remove_deploy_path
      @task.info '=> Done.'
    end

    private

    def remove_deploy_path
      @task.info 'Removing crypti...'
      @task.execute 'rm', '-rf', Core.deploy_path
    end

    def remove_install_path
      @task.info 'Removing crypti...'
      @task.execute 'rm', '-rf', Core.install_path
    end

    def make_deploy_path
      @task.info 'Making deploy path...'
      @task.execute 'mkdir', '-p', Core.deploy_path
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
      @task.execute 'wget', app_url, '-O', zip_file
    end

    def install_crypti
      @task.info 'Installing crypti...'
      @task.execute 'unzip', '-u', zip_file
      @task.execute 'mv', '-f', '$(ls -d * | head -1)', Core.install_path
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
