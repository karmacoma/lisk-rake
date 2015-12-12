module CryptiKit
  class Recipient
    attr_reader :address

    def address=(address)
      unless address.match(/[0-9]{18,20}C/) then
        raise ArgumentError
      else
        @address = address
      end
    end

    def specified
      @specified ||= (
        specified = ENV['recipient'].to_s.chomp
        specified if specified.size > 0
      )
    end

    def get_address
      if specified then
        self.address = specified
      else
        puts Color.yellow("Please enter your recipient crypti address:")
        self.address = STDIN.gets.chomp
      end
    rescue Interrupt
      puts ''
      exit
    rescue ArgumentError
      @specified = ENV['recipient'] = nil
      puts Color.red("Invalid crypti address. Please try again...")
      retry
    end
  end
end
