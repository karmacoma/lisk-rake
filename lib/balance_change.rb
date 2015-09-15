module CryptiKit
  class BalanceChange
    def initialize(cur, pre)
      @cur = to_xcr(cur)
      @pre = to_xcr(pre)
    end

    def to_xcr(val)
      if val.is_a?(String) or val.is_a?(Integer) then
        val.to_xcr
      else
        val
      end
    end

    def abs
      "%.8f" % (@cur - @pre).abs
    end

    def to_s
      case
      when @pre.nil? then
        blue("\s0.0 (*)")
      when @cur < @pre then
        red("\s#{abs} (-)")
      when @cur > @pre then
        green("\s#{abs} (+)")
      else
        yellow("\s#{abs} (=)")
      end
    end
  end
end
