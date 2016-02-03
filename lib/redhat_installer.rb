module LiskRake
  class RedhatInstaller
    PACKAGES = ['bash', 'curl', 'psmisc.x86_64', 'unzip']

    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      Core.task do
        @deps.check_remote('sudo', 'yum')

        @task.info 'Updating package lists...'
        Netssh.pty { @task.execute %(sudo -S yum clean expire-cache), interaction_handler: SudoHandler.new }
        @task.info 'Installing packages...'
        Netssh.pty { @task.execute %(sudo -S yum install -y #{PACKAGES.join("\s")}), interaction_handler: SudoHandler.new }
        @task.info '=> Done.'
      end
    end
  end

  class CentosInstaller < RedhatInstaller; end
  class FedoraInstaller < RedhatInstaller; end
end
