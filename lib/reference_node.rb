require 'singleton'
require 'net/http'
require 'json'

module CryptiKit
  class ReferenceNode
    include Singleton

    def self.query
      @host = validate(Core.reference_node)

      uri = URI("http://#{@host}:#{Core.app_port}/api/peers?state=2&limit=100")
      uri.query = URI.encode_www_form({ :ip => @host, :port => Core.app_port })

      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess) then
        @data = parse(res) rescue {}
      else
        @data = {}
      end
    end

    def self.to_h
      @data || query
    end

    def self.version
      to_h['peer']['version'] rescue nil
    end

    private

    def self.validate(host)
      if host.match(/\A([0-9]+\.){3}([0-9]+)\Z/) then
        host
      else
        '127.0.0.1'
      end
    end

    def self.parse(res)
      json = JSON.parse(res.body)
      { 'success' => json['success'],
        'peer'    => json['peers'].sort_by { |p| p['version'] }.last }
    end
  end
end
