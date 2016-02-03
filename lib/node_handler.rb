module LiskRake
  class NodeHandler
    def on_data(command, stream_name, data, channel)
      if data.size > 1 then
        raise data
      end
    end
  end
end
