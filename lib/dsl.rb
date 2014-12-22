module CryptiKit
  module DSL
    def on_node(server, &block)
      begin
        node = Node.new(server)
        deps = DependencyManager.new(self)
        info node.info
        instance_exec(server, node, deps, &block)
        return true
      rescue Exception => exception
        error = ServerError.new(self, exception)
        CryptiKit.baddies << error.collect(node, error)
        return false
      end
    end

    def on_each_server(&block)
      CryptiKit.baddies.clear
      chooser = ServerChooser.new(:values)
      on(chooser.choose, { :in => :sequence, :wait => 0 }) do |server|
        next unless on_node(server, &block)
      end
    end

    def each_server(&block)
      CryptiKit.baddies.clear
      chooser = ServerChooser.new(:values)
      chooser.choose.each do |server|
        run_locally { next unless on_node(server, &block) }
      end
    end
  end
end

include CryptiKit::DSL
