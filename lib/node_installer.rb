module CryptiKit
  class NodeInstaller
    def initialize(task)
      @task    = task
      @manager = NodeManager.new(task)
    end

    def install
      @manager.stop_all
      remove_deploy_path
      make_deploy_path
      @task.within Core.deploy_path do
        download_crypti
        install_crypti
      end
      @task.within Core.install_path do
        download_blockchain
        install_modules
      end
      @manager.start
    end

    def rebuild
      @manager.stop
      @task.within Core.install_path do
        remove_blockchain
        download_blockchain
      end
      @manager.start
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

    def make_deploy_path
      @task.info 'Making deploy path...'
      @task.execute 'mkdir', '-p', Core.deploy_path
    end

    def download_crypti
      @task.info 'Downloading crypti...'
      @task.execute 'wget', Core.app_url, '-O', Core.app_file
    end

    def install_crypti
      @task.info 'Installing crypti...'
      @task.execute 'unzip', Core.app_file
      @task.info 'Cleaning up...'
      @task.execute 'rm', Core.app_file
    end

    def remove_blockchain
      @task.info 'Removing blockchain...'
      @task.execute 'rm', '-f', 'blockchain.db*'
    end

    def download_blockchain
      @task.info 'Downloading blockchain...'
      @task.execute 'wget', Core.blockchain_url, '-O', Core.blockchain_file
      @task.info 'Decompressing blockchain...'
      @task.execute 'unzip', Core.blockchain_file
      @task.info 'Cleaning up...'
      @task.execute 'rm', Core.blockchain_file
    end

    def install_modules
      @task.info 'Installing node modules...'
      @task.execute 'npm', 'install'
    end
  end
end
