module CryptiKit
  class Passphrase
    def initialize(passphrase)
      @passphrase = passphrase.to_s.strip
    end

    def self.gets
      self.new(STDIN.noecho(&:gets).chomp).raw
    end

    def self.escaped(passphrase)
      self.new(passphrase).escaped
    end

    def raw
      @passphrase
    end

    ESCAPED_CHARS = {
      /"/  => %q{\\\"},
      /'/  => %q{\x27},
      /\^/ => %q{\^},
      /\$/ => %q{\$},
      /\./ => %q{\.},
      /\*/ => %q{\*},
      /\// => %q{\/},
      /\\/ => %q{\\},
      /\[/ => %q{\[},
      /\]/ => %q{\]},
      /\&/ => %q{\&},
    }

    def escaped
      @escaped = @passphrase.dup
      ESCAPED_CHARS.each_pair { |k,v| @escaped.gsub!(/#{k}/, &Proc.new { v }) }
      @escaped
    end
  end
end
