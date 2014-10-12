class ServerChooser
  def choices
    CryptiKit.configured_servers
  end

  def chosen
    @chosen ||= ENV['servers'].to_s.chomp
  end

  def choose
    puts 'Choosing servers...'
    case chosen
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
    choices.values
  end

  def accept_all?
    print yellow("No servers chosen. Do you want to run this task on all servers?\s")
    STDIN.gets.chomp.match(/y|yes/i)
  end

  def accept_range
    puts '=> Accepting range of servers.'
    servers = Range.new(*chosen.split('..').map(&:to_i)).to_a
    servers.collect { |s| choices[s.to_i] }.compact
  end

  def accept_selection
    puts '=> Accepting selection of servers.'
    servers = ServerList.parse_keys(chosen)
    servers.collect { |s| choices[s.to_i] }.compact
  end
end