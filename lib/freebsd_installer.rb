module CryptiKit
  class FreeBSDInstaller
    PACKAGES = ['bash', 'curl', 'wget', 'unzip']

    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      Core.task do
        @deps.check_remote('sudo', 'pkg')

        @task.info 'Installing packages...'
        @task.execute %(sudo -S pkg install -y #{PACKAGES.join("\s")}), interaction_handler: SudoHandler.new
        @task.test %(echo $SHELL | grep 'bash') or setup_bash
        @task.info '=> Done.'
      end
    end

    private

    def setup_bash
      @task.info 'Mounting fdesc file system...'
      @task.execute %(sudo sh -c 'echo "fdesc /dev/fd fdescfs rw 0 0" >> /etc/fstab'$)
      @task.execute %(sudo mount -a)
      @task.info 'Changing default shell to bash...'
      @task.execute %(sudo chsh -s /usr/local/bin/bash #{@node.user})
    end
  end
end
