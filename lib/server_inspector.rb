module CryptiKit
  class ServerInspector
    SUPPORTED_ARCHS  = /x86_64/i
    SUPPORTED_DISTS  = /debian|ubuntu/i

    def initialize(task)
      @task = task
    end

    def release
      if !@release and @task.test 'which', 'cat' then
        @release ||= @task.capture 'cat', '/etc/*-release'
      else
        @release
      end
    end

    def dist
      m = release.to_s.match(SUPPORTED_DISTS)
      m[0] if m
    end

    def base
      case dist
      when SUPPORTED_DISTS then
        :debian
      end
    end

    def arch
      if !@arch and @task.test 'which', 'uname' then
        @arch ||= @task.capture 'uname', '-m'
      else
        @arch
      end
    end

    def detect_arch
      @task.info 'Detecting architecture...'
      case arch
      when SUPPORTED_ARCHS then
        @task.info "=> Found: #{arch}"
        return arch.downcase.to_sym
      else
        raise 'Unsupported architecture detected.'
      end
    end

    def detect_dist
      @task.info 'Detecting distribution...'
      case dist
      when SUPPORTED_DISTS then
        @task.info "=> Found: #{dist}"
        return dist.downcase.to_sym
      else
        raise 'Unsupported distribution detected.'
      end
    end

    def detect
      [detect_arch, detect_dist]
    end
  end
end
