module CryptiKit
  class ForgingManager
    def initialize(task)
      @task = task
      @api  = CryptiKit::Curl.new(@task)
    end

    def start(server, node)
      node.get_passphrase do |passphrase|
        @api.post '/forgingApi/startForging', passphrase
        @api.post '/api/unlock', passphrase do |json|
          manager = CryptiKit::AccountManager.new(@task, server)
          manager.add(json, passphrase)
        end
      end
    end

    def stop(server, node)
      node.get_passphrase do |passphrase|
        @api.post '/forgingApi/stopForging', passphrase do |json|
          manager = CryptiKit::AccountManager.new(@task, server)
          manager.remove(json)
        end
      end
    end
  end
end
