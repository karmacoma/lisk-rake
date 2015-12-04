module CryptiKit
  class NodeInstaller
    def initialize(task)
      @task    = task
      @manager = NodeManager.new(@task)
    end

    def install
      @manager.stop
      remove_deploy_path
      make_deploy_path
      @task.within Core.deploy_path do
        download_crypti
        install_crypti
        download_crypti_node
        install_crypti_node
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

    def reinstall
      @manager.stop
      @task.within Core.install_path do
        save_blockchain
      end
      remove_install_path
      @task.within Core.deploy_path do
        download_crypti
        install_crypti
        download_crypti_node
        install_crypti_node
      end
      @task.within Core.install_path do
        restore_blockchain
        install_modules
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

    def remove_install_path
      @task.info 'Removing crypti...'
      @task.execute 'rm', '-rf', Core.install_path
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
      @task.execute 'unzip', '-u', Core.app_file, '-d', Core.install_path
      @task.info 'Cleaning up...'
      @task.execute 'rm', '-f', Core.app_file
    end

    def download_crypti_node
      @task.info 'Dowloading crypti-node...'
      @task.execute 'wget', 'http://downloads.cryptichain.me/crypti-node.zip'
    end

    def install_crypti_node
      @task.info 'Installing crypti-node...'
      @task.execute 'unzip', '-u', 'crypti-node.zip', '-d', Core.install_path
      @task.info 'Cleaning up...'
      @task.execute 'rm', '-f', 'crypti-node.zip'
    end

    def save_blockchain
      @task.info 'Saving blockchain...'
      @task.execute 'cp', '-f', 'blockchain.db', '../blockchain.db.bak'
    end

    def restore_blockchain
      @task.info 'Restoring blockchain...'
      @task.execute 'cp', '-f', '../blockchain.db.bak', 'blockchain.db'
    end

    def remove_blockchain
      @task.info 'Removing blockchain...'
      @task.execute 'rm', '-f', 'blockchain.db*'
    end

    def download_blockchain?
      Core.blockchain_url.to_s.size > 0
    end

    def download_blockchain
      return unless download_blockchain?
      @task.info 'Downloading blockchain...'
      @task.execute 'wget', Core.blockchain_url, '-O', Core.blockchain_file
      @task.info 'Decompressing blockchain...'
      @task.execute 'unzip', '-u', Core.blockchain_file
      @task.info 'Cleaning up...'
      @task.execute 'rm', Core.blockchain_file
    end

    def install_modules
      @task.info 'Installing node modules...'
      @task.execute 'npm', 'install', '--production'
    end
  end
end
