module CryptiKit
  class DarwinInstaller
    def initialize(task, node, deps)
      @task = task
      @node = node
      @deps = deps
    end

    def install
      @deps.check_remote('brew')

      @task.execute 'brew', 'install', 'pstree'
    end
  end
end
