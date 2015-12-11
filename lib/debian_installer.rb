module CryptiKit
  class DebianInstaller
    PACKAGES = ['bash', 'curl', 'wget', 'unzip']

    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      Core.task do
        if @task.test 'sudo', '-h' then
          install_sudo
        else
          install_su
        end
      end
    end

    private

    def install_sudo
      @deps.check_remote('sudo', 'apt-get')

      @task.info 'Updating package lists...'
      @task.execute %(sudo -S apt-get update), interaction_handler: SudoHandler.new
      @task.info 'Installing packages...'
      @task.execute %(sudo -S apt-get install -f --yes #{PACKAGES.join("\s")}), interaction_handler: SudoHandler.new
      @task.info '=> Done.'
    end

    def install_su
      @deps.check_remote('su', 'apt-get')

      Netssh.pty do
        @task.info 'Updating package lists...'
        @task.execute %(su - -c 'apt-get update'), interaction_handler: SuHandler.new
        @task.info 'Installing packages...'
        @task.execute %(su - -c 'apt-get install -f --yes #{PACKAGES.join("\s")}'), interaction_handler: SuHandler.new
        @task.info '=> Done.'
      end
    end
  end

  class UbuntuInstaller < DebianInstaller; end
end
