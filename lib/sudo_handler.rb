module CryptiKit
  class SudoHandler
    def on_data(command, stream_name, data, channel)
      case data
      when /\[sudo\] password/ then
        puts data
        get_password(data, channel)
      end
    end

    private

    def get_password(data, channel)
      channel.send_data("#{STDIN.noecho(&:gets).chomp}\n")
      puts
    end
  end
end
