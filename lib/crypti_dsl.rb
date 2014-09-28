module CryptiDSL
  def on_node(kit, server, &block)
    begin
      node = CryptiNode.new(kit.config, server)
      deps = DependencyManager.new(self, kit)
      info node.info
      instance_exec(server, node, deps, &block)
      return true
    rescue Exception => exception
      error = ServerError.new(self, exception)
      kit.baddies << error.collect(node, error)
      return false
    end
  end

  def on_each_server(kit, &block)
    chooser = ServerChooser.new(kit)
    on(chooser.choose, kit.sequenced_exec) do |server|
      next unless on_node(kit, server, &block)
    end
  end

  def each_server(kit, &block)
    chooser = ServerChooser.new(kit)
    chooser.choose.each do |server|
      run_locally { next unless on_node(kit, server, &block) }
    end
  end
end

include CryptiDSL