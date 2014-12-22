module CryptiKit
  class ServerChooser
    def initialize(mode)
      @mode = mode
    end

    def choices
      CryptiKit.configured_servers
    end

    def args
      @args ||= ENV['servers'].to_s.strip
    end

    def choose
      puts 'Choosing servers...'
      case args
      when /all/ then
        accept_all
      when /[0-9]+\.\.[0-9]+/ then
        accept_range
      when /[0-9,]+/ then
        accept_selection
      else
        if accept_all? then
          ENV['servers'] = 'all'
          accept_all
        else
          []
        end
      end
    end

    private

    def accept_all
      puts '=> Accepting all servers.'
      @mode == :keys ? choices.keys : choices.values
    end

    def accept_all?
      print yellow("No servers selected. Run task on all servers?\s")
      STDIN.gets.chomp.match(/y|yes/i)
    end

    def select_servers(servers)
      if @mode == :keys then
        servers.collect! { |s| s.to_i if choices.has_key?(s.to_i) }
      else
        servers.collect! { |s| choices[s.to_i] }
      end
      servers.compact
    end

    def accept_range
      puts '=> Accepting range of servers.'
      servers = Range.new(*args.split('..').map(&:to_i)).to_a
      select_servers(servers)
    end

    def accept_selection
      puts '=> Accepting selection of servers.'
      servers = ServerList.parse_keys(args)
      select_servers(servers)
    end
  end
end
