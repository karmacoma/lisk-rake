require 'basic_error'

module LiskRake
  class KeyError < BasicError
    @errors = {
      /Your password has expired/i    => :expired_password,
      /Host key verification failed/i => :verification_failed,
      /Permission denied/i            => '=> Failed. Check password.',
      /Network is unreachable/        => '=> Network is unreachable.',
      /Connection closed/i            => '=> Connection closed by remote host.',
      /Connection timed out/i         => '=> Connection timed out.',
      /Connection refused/i           => '=> Connection refused.'
    }

    def detect(server)
      @server = server
      super()
    end

    def try_again?
      @retry == true
    end

    private

    def try_again
      @task.info 'Trying to add public ssh key again...'
      @retry = true
    end

    def expired_password
      @task.warn 'Password change required. Please login and change password...'
      system "ssh -t #{Core.ssh_options(@server)} exit"
      try_again
    end

    def verification_failed
      @task.warn 'Host key verification failed. Removing server from known hosts...'
      @task.execute 'ssh-keygen', '-R', @server
      try_again
    end
  end
end
