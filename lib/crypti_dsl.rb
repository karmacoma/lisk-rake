module CryptiDSL
  def on_node(server, &block)
    begin
      node = CryptiNode.new(server)
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
    chooser = ServerChooser.new
    on(chooser.choose, CryptiKit.sequenced_exec) do |server|
      next unless on_node(server, &block)
    end
  end

  def each_server(&block)
    CryptiKit.baddies.clear
    chooser = ServerChooser.new
    chooser.choose.each do |server|
      run_locally { next unless on_node(server, &block) }
    end
  end
end

include CryptiDSL