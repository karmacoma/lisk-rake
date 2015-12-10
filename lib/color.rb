require 'singleton'
require 'sshkit'

module CryptiKit
  class Color
    include Singleton

    @output = SSHKit.config.output.original_output
    @color  = SSHKit::Color.new(@output)

    def self.red(string)
      @color.colorize(string, :red)
    end

    def self.green(string)
      @color.colorize(string, :green)
    end

    def self.light_blue(string)
      @color.colorize(string, :light_blue)
    end

    def self.yellow(string)
      @color.colorize(string, :yellow)
    end
  end
end
