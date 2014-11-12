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

  def escaped
    @escaped = @passphrase.dup
    [[/"/, Proc.new { %q{\\\"} }]].each { |a| @escaped.gsub!(a[0], &a[1]) }
    @escaped
  end
end
