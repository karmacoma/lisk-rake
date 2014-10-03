module Colourise
  def red(string)
    string.colorize(:red)
  end

  def green(string)
    string.colorize(:green)
  end

  def blue(string)
    string.colorize(:blue)
  end

  def yellow(string)
    string.colorize(:yellow)
  end
end

include Colourise
