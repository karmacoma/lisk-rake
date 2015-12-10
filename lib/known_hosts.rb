module CryptiKit
  class KnownHosts
    def initialize(list)
      @list = list
    end

    def path
      @path ||= ENV['HOME'] + '/.ssh/known_hosts'
    end

    def file
      if !@file and File.exists?(path) then
        @file = File.read(path)
      else
        @file
      end
    end

    def forget(servers)
      return unless file
      File.open(path, 'w') do |f|
        @list.class.parse_values(servers).each do |server|
          file.gsub!(/^#{server['hostname']}.+\n$/, '')
        end
        f.puts file
      end
    end
  end
end
