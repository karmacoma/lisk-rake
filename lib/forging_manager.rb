module CryptiKit
  class ForgingManager
    def initialize(task)
      @task = task
      @api  = Curl.new(@task)
    end

    def start(server, node)
      return unless loaded?
      node.get_passphrase do |passphrase|
        @task.info 'Enabling forging...'
        @api.post '/api/forging/enable', passphrase do |json|
          if json['success'] then
            @task.info '=> Enabled.'
            manager = AccountManager.new(@task, server)
            manager.add(passphrase)
          else
            @task.error '=> Failed.'
          end
        end
      end
    end

    def stop(server, node)
      return unless loaded?
      node.get_passphrase do |passphrase|
        @task.info 'Disabling forging...'
        @api.post '/api/forging/disable', passphrase do |json|
          if json['success'] then
            @task.info '=> Disabled.'
            manager = AccountManager.new(@task, server)
            manager.remove(passphrase)
          else
            @task.error '=> Failed.'
          end
        end
      end
    end

    private

    def loaded?
      NodeInspector.loaded?(@task)
    end
  end
end
