require 'basic_error'

module LiskRake
  class CurlError < BasicError
    @errors = {
      /curl exit status: 7/i  => '=> Connection failed.',
      /curl exit status: 28/i => '=> Operation timed out.'
    }
  end
end
