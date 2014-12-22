require 'basic_error'

module CryptiKit
  class KeyError < BasicError
    def detect(server)
      @server = server
      case @exception.to_s
      when /Your password has expired/ then
        expired_password
        try_again
      when /Host key verification failed/ then
        verification_failed
        try_again
      when /Permission denied, please try again/ then
        permission_denied
      else
        unknown_error
      end
    end

    def try_again
      @task.info 'Trying to add public ssh key again...'
      @retry = true
    end

    def try_again?
      @retry == true
    end

    def expired_password
      @task.warn 'Password change required. Please login and change password...'
      system "ssh -t #{CryptiKit.deploy_user_at_host(server)} exit"
    end

    def verification_failed
      @task.warn 'Host key verification failed. Removing server from known hosts...'
      @task.execute 'ssh-keygen', '-R', @server
    end

    def permission_denied
      @task.error '=> Failed. Check password.'
    end
  end
end
