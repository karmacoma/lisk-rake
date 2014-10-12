#!/usr/bin/env ruby

require 'singleton'
require 'fileutils'

class Completer
  include Singleton

  def self.rake_file
    @rake_file ||= File.join(Dir.pwd, 'Rakefile')
  end

  def self.cache_file
    @cache_file ||= File.join(Dir.pwd, '.tasks')
  end

  def self.tasks
    if File.exist?(cache_file) then
      @tasks = File.read(cache_file)
    else
      @tasks = `rake --silent --tasks 2>/dev/null`
      File.open(cache_file, 'w') do |f| f << @tasks; end
    end
    return @tasks
  end

  def self.task_match
    unless @match.to_s.empty? || @match =~ /\s$/ then
      @match.split.last
    end
  end

  def self.complete
    exit 0 unless File.file?(rake_file)
    exit 0 unless /^rake\b/ =~ ENV["COMP_LINE"]

    @match = $'
    tasks.split("\n").collect { |l| l.split[1] }.select do |t|
      /^#{Regexp.escape task_match}/ =~ t
    end if task_match
  end
end

class Installer
  include Singleton

  @@command_line = /^.*\/completer.rb' -o default rake\n$/

  def self.config
    @config ||= ENV['HOME'] + '/.bash_profile'
  end

  def self.command
    @command ||= "complete -C 'ruby #{this_file}' -o default rake"
  end

  def self.this_file
    @this_file ||= File.expand_path(File.dirname(__FILE__)) + '/completer.rb'
  end

  def self.enable
    tmp = File.read(config)
    return if tmp.match(command)
    File.open(config, 'a') { |f| f.puts command }
  end

  def self.disable
    tmp = File.read(config)
    while tmp.match(@@command_line) do
      tmp.gsub!(@@command_line, '')
    end
    File.open(config, 'w') { |f| f.puts tmp }
  end
end

case ARGV.first.to_s
when '--enable' then
  Installer.enable
when '--disable' then
  Installer.disable
when '--re-enable' then
  Installer.disable
  Installer.enable
else
  puts Completer.complete
end
