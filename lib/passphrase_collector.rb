module CryptiKit
  class PassphraseCollector
    def passphrases
      @passphrases ||= {}
    end

    def get(args = nil, &block)
      args ||= ['primary', 'secret']
      puts Color.yellow("Please enter your #{args.first} passphrase:")
      passphrases.merge!(args.last.to_sym => Passphrase.gets) and puts
      block_given? ? block.call(passphrases) : passphrases
    end

    def collect(args = nil, &block)
      args.each { |arg| get(arg) }
      block_given? ? block.call(passphrases) : passphrases
    end

    def self.get(args = nil, &block)
      self.new.get(args, &block)
    end

    def self.collect(args = nil, &block)
      self.new.collect(args, &block)
    end
  end
end
