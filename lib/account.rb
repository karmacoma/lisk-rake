class Account
  attr_reader :address

  def address=(address)
    unless address.match(/[0-9]{19}C/) then
      raise ArgumentError
    else
      @address = address
    end
  end

  def specified
    @specified ||= (
      specified = ENV['address'].to_s.chomp
      specified if specified.size > 0
    )
  end

  def get_address
    if specified then
      self.address = specified
    else
      print yellow("Please enter your crypti address:\s")
      self.address = STDIN.gets.chomp
    end
  rescue Interrupt
    puts and exit
  rescue ArgumentError
    @specified = ENV['address'] = nil
    print red("Invalid crypti address. Please try again...\n")
    retry
  end
end
