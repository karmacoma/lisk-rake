require 'bigdecimal'

module ToXCR
  def to_bd
    BigDecimal.new((self.to_f / 10**8).to_s)
  end

  def to_xcr
    to_bd.to_xcr
  end
end

class NilClass
  include ToXCR
end

class String
  include ToXCR
end

class Integer
  include ToXCR
end

class Float
  include ToXCR
end

class BigDecimal
  def to_xcr
    self.floor(8).to_f
  end
end
