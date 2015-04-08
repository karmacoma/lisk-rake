module CryptiKit
  module Colourise
    def red(string)
      string.colorize(:red)
    end

    def green(string)
      string.colorize(:green)
    end

    def blue(string)
      string.colorize(:light_blue)
    end

    def yellow(string)
      string.colorize(:yellow)
    end
  end
end

include CryptiKit::Colourise
