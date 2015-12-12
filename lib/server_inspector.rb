module CryptiKit
  class ServerInspector
    SUPPORTED_PLATS = {
      'FreeBSD' => /amd64/i,
      'Linux' => /x86_64|i686|armv6l|armv7l/i
    }

    def initialize(task)
      @task = task
    end

    def os
      if !@os and @task.test 'which', 'uname' then
        @os ||= @task.capture 'uname', '-s'
      else
        @os
      end
    end

    def arch
      if !@arch and @task.test 'which', 'uname' then
        @arch ||= @task.capture 'uname', '-m'
      else
        @arch
      end
    end

    def detect_os
      @task.info 'Detecting os...'
      if SUPPORTED_PLATS.has_key?(os) then
        @task.info "=> Found: #{os}"
        return os.downcase.to_sym
      else
        raise 'Unsupported os detected.'
      end
    end

    def detect_arch
      @task.info 'Detecting architecture...'
      if os and arch =~ SUPPORTED_PLATS[os] then
        @task.info "=> Found: #{arch}"
        return arch.downcase.to_sym
      else
        raise 'Unsupported architecture detected.'
      end
    end

    def detect
      [detect_os, detect_arch]
    end
  end
end
