module CryptiKit
  class SuHandler
    def on_data(command, stream_name, data, channel)
      case data
      when /^Password/ then
        puts 'Enter password for root:'
        get_password(data, channel)
      when /^You are required to change your password/,
           /^Changing password for root/,
           /^Sorry, passwords do not match/,
           /^You must choose a longer password/,
           /^Password unchanged/ then
        puts data
      when /^\(current\) UNIX password/,
           /^Enter new UNIX password/,
           /^Retype new UNIX password/ then
        puts data
        get_password(data, channel)
      end
    end

    private

    def get_password(data, channel)
      channel.send_data("#{Core.gets_password}\n")
      puts
    end
  end
end
