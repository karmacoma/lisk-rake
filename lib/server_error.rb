require 'basic_error'

module CryptiKit
  class ServerError < BasicError
    @errors = {
      /Authentication failed/i  => '=> Authentication failed.',
      /Network is unreachable/i => '=> Network is unreachable.',
      /Connection closed/i      => '=> Connection closed by remote host.',
      /Connection timed out/i   => '=> Connection timed out.',
      /Connection refused/i     => '=> Connection refused.'
    }

    def collect(node, error)
      { 'key' => node.key, 'error' => error.detect }
    end
  end
end
