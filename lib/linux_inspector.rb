module CryptiKit
  class LinuxInspector
    SUPPORTED_DISTS = /Debian|Ubuntu|Centos|Fedora|Redhat/i

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
      m[0].to_s.downcase.capitalize if m
    end

    def detect_dist
      @task.info 'Detecting distribution...'
      if dist then
        @task.info "=> Found: #{dist}"
        return dist.downcase.to_sym
      else
        raise 'Unsupported distribution detected.'
      end
    end

    def detect
      [detect_dist]
    end
  end
end
