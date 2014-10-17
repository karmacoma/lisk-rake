class CryptiAccount
  attr_reader :address

  def address=(address)
    unless address.match(/[0-9]{19}C/) then
      raise ArgumentError
    else
      @address = address
    end
  end

  def get_address
    print yellow("Please enter your crypti address:\s")
    self.address = STDIN.gets.chomp
  rescue Interrupt
    puts and exit
  rescue ArgumentError
    print red("Invalid crypti address. Please try again...\n")
    retry
  end
end