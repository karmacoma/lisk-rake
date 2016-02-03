require 'bigdecimal'

module ToLISK
  def to_bd
    BigDecimal.new((self.to_f / 10**8).to_s)
  end

  def to_lisk
    to_bd.to_lisk
  end
end

class NilClass
  include ToLISK
end

class String
  include ToLISK
end

class Integer
  include ToLISK
end

class Float
  include ToLISK
end

class BigDecimal
  def to_lisk
    self.floor(8).to_f
  end
end
