module CryptiKit
  class BalanceChange
    def initialize(cur, pre)
      @cur = to_xcr(cur)
      @pre = to_xcr(pre)
    end

    def to_xcr(val)
      val.is_a?(Integer) ? val.to_xcr : val
    end

    def abs
      (@cur - @pre).abs
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
