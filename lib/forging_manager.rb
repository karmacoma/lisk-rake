module CryptiKit
  class ForgingManager
    def initialize(task, node)
      @task = task
      @node = node
      @api  = Curl.new(@task)
    end

    def start
      return unless loaded?
      another = true
      while another do
        enable_one
        another = enable_another?
      end
    end

    def stop
      return unless loaded?
      another = true
      while another do
        disable_one
        another = disable_another?
      end
    end

    private

    def loaded?
      NodeInspector.loaded?(@task, @node)
    end

    def enable_one
      PassphraseCollector.get do |passphrase|
        @task.info 'Enabling forging...'
        @api.post '/api/delegates/forging/enable', passphrase do |json|
          if json['success'] then
            @task.info '=> Enabled.'
            manager = AccountManager.new(@task, @node)
            manager.add(passphrase)
          else
            @task.error '=> Failed.'
          end
        end
      end
    end

    def enable_another?
      puts Color.yellow("Enable forging for another delegate?")
      Core.gets.match(/y|yes/i)
    end

    def disable_one
      PassphraseCollector.get do |passphrase|
        @task.info 'Disabling forging...'
        @api.post '/api/delegates/forging/disable', passphrase do |json|
          if json['success'] then
            @task.info '=> Disabled.'
            manager = AccountManager.new(@task, @node)
            manager.remove(passphrase)
          else
            @task.error '=> Failed.'
          end
        end
      end
    end

    def disable_another?
      puts Color.yellow("Disable forging for another delegate?")
      Core.gets.match(/y|yes/i)
    end
  end
end
