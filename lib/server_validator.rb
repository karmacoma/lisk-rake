module CryptiKit
  class ServerValidator
    IPV4_REGEXP = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
    HOST_REGEXP = /^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$/i
    USER_REGEXP = /^[a-z0-9_\-.]{1,32}$/i
    PATH_REGEXP = /^[^\0]+$/

    HOST_VALIDATOR = Proc.new do |server|
      ServerValidator.valid_host?(server['hostname'])
    end

    USER_VALIDATOR = Proc.new do |server|
      ServerValidator.valid_user?(server['user'])
    end

    PORT_VALIDATOR = Proc.new do |server|
      ServerValidator.valid_port?(server['port'])
    end

    DEPLOY_PATH_VALIDATOR = Proc.new do |server|
      ServerValidator.valid_path?(server['deploy_path'])
    end

    CRYPTI_PATH_VALIDATOR = Proc.new do |server|
      ServerValidator.valid_path?(server['lisk_path'])
    end

    VALIDATORS = {
      'hostname'    => HOST_VALIDATOR,
      'user'        => USER_VALIDATOR,
      'port'        => PORT_VALIDATOR,
      'deploy_path' => DEPLOY_PATH_VALIDATOR,
      'lisk_path' => CRYPTI_PATH_VALIDATOR
    }

    def initialize(args)
      @valid   = []
      @servers = parse_args(args)
    end

    attr_reader :valid

    def valid?(server)
      errors = []
      server = {} unless server.is_a?(Hash)
      VALIDATORS.each_pair do |k,validator|
        unless validator.call(server) then
          errors.push(k)
        end
      end
      if errors.any? then
        server['errors'] = errors
        return false
      else
        return true
      end
    end

    def validate
      @servers.each_with_index do |server,i|
        prefix = %(Server #{i + 1} of #{@servers.size})
        if valid?(server) then
          puts Color.green(%(>>>> #{prefix} is valid))
          @valid.push(server)
        else
          puts Color.red(%(>>>> #{prefix} has invalid: #{server['errors'].join(",\s")}))
        end
      end
    end

    def self.validate(args)
      validator = self.new(args)
      validator.validate
      validator
    end

    def self.valid_host?(host)
      host = host.to_s
      host =~ IPV4_REGEXP || host =~ HOST_REGEXP
    end

    def self.valid_user?(user)
      user.to_s =~ USER_REGEXP
    end

    def self.valid_port?(port)
      port = port.to_i
      port >= 1 && port <= 65535
    end

    def self.valid_path?(path)
      path.to_s =~ PATH_REGEXP
    end

    private

    def parse_args(args)
      case args
      when String then
        ServerList.parse_values(args)
      when Array then
        args
      end
    end
  end
end
