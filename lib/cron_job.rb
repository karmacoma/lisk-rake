module CryptiKit
  class CronJob
    def initialize(task)
      @task = task
      @job  = job
    end

    def add
      @task.info 'Adding cron job...'
      @task.execute %Q{( crontab -l | grep -v "#{@job}" ; echo "#{@job}" ) | crontab -}
    end

    def remove
      @task.info 'Removing cron job...'
      @task.execute %Q{( crontab -l | grep -v "#{@job}" ) | crontab -}
    end

    private

    def job
      forever_path = @task.capture 'which', 'forever'
      %Q{@reboot #{forever_path} start #{Core.install_path}/app.js}
    end
  end
end
