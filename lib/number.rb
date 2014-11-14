require 'bigdecimal'

class NilClass
  def to_bd
    BigDecimal.new('0.0')
  end

  def to_xcr
    to_bd.to_xcr
  end
end

class Integer
  def to_bd
    BigDecimal.new((self.to_f / 10**8).to_s)
  end

  def to_xcr
    to_bd.to_xcr
  end
end

class Float
  def to_bd
    BigDecimal.new((self.to_f / 10**8).to_s)
  end

  def to_xcr
    to_bd.to_xcr
  end
end

class BigDecimal
  def to_xcr
    self.floor(8).to_f
  end
end
