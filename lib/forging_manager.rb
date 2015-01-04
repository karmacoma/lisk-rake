module CryptiKit
  class ForgingManager
    def initialize(task)
      @task = task
      @api  = Curl.new(@task)
    end

    def start(server, node)
      return unless loaded?
      node.get_passphrase do |passphrase|
        @api.post '/forgingApi/startForging', passphrase
        @api.post '/api/unlock', passphrase do |json|
          manager = AccountManager.new(@task, server)
          manager.add(json, passphrase)
        end
      end
    end

    def stop(server, node)
      return unless loaded?
      node.get_passphrase do |passphrase|
        @api.post '/forgingApi/stopForging', passphrase do |json|
          manager = AccountManager.new(@task, server)
          manager.remove(json)
        end
      end
    end

    private

    def loaded?
      NodeInspector.loaded?(@task)
    end
  end
end
