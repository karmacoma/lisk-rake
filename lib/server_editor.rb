module CryptiKit
  class ServerEditor
    def initialize(task, list)
      @task = task
      @list = list
    end

    def edit_all(keys)
      @task.info "Editing server(s)..."
      @validator = ServerValidator.new(@task)
      keys.each { |key| edit(key) }
    end

    def edit(key)
      if server = @list[key] then
        @task.info "Editing server: #{Color.green(server['hostname'])}"
        edit_user(server)
        edit_port(server)
        edit_deploy_path(server)
        edit_lisk_path(server)
      end
    end

    def edit_user(server)
      begin
        puts Color.yellow("Enter user (current = #{server['user']}):")
        if ServerValidator.valid_user?(user = Core.gets) then
          server['user'] = user
        elsif !user.empty? then
          raise ArgumentError
        else
          puts Color.light_blue(%(User remains unchanged))
        end
      rescue ArgumentError
        puts Color.red("Invalid user. Please try again...")
        retry
      end
    end

    def edit_port(server)
      begin
        puts Color.yellow("Enter port (current = #{server['port']}):")
        if ServerValidator.valid_port?(port = Core.gets) then
          server['port'] = port
        elsif !port.empty? then
          raise ArgumentError
        else
          puts Color.light_blue(%(Port remains unchanged))
        end
      rescue ArgumentError
        puts Color.red("Invalid port. Please try again...")
        retry
      end
    end

    def edit_deploy_path(server)
      begin
        puts Color.yellow("Enter deploy path (current = #{server['deploy_path']}):")
        if ServerValidator.valid_path?(path = Core.gets) then
          server['deploy_path'] = sanitize_path(path)
        elsif !path.empty? then
          raise ArgumentError
        else
          puts Color.light_blue(%(Deploy path remains unchanged))
        end
      rescue ArgumentError
        puts Color.red("Invalid deploy path. Please try again...")
        retry
      end
    end

    def edit_lisk_path(server)
      begin
        puts Color.yellow("Enter lisk path (current = #{server['lisk_path']}):")
        if ServerValidator.valid_path?(path = Core.gets) then
          server['lisk_path'] = sanitize_path(path)
        elsif !path.empty? then
          raise ArgumentError
        else
          puts Color.light_blue(%(Lisk path remains unchanged))
        end
      rescue ArgumentError
        puts Color.red("Invalid lisk path. Please try again...")
        retry
      end
    end

    private

    def sanitize_path(path)
      unless path =~ /^[\/]{1}/ || path =~ /^\$HOME/ then
        path = %(/#{path})
      end
      path.gsub!(/\/$/, '')
      path
    end
  end
end
