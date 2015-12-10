#!/usr/bin/env ruby

require 'yaml'
require 'singleton'

class ConfigUpdater
  include Singleton

  @config_bak = @config_yml = {}

  def self.load_config(extension)
    file = File.join(Dir.pwd, "config.#{extension}")

    if File.exist?(file) then
      yaml = YAML.load_file(file)

      if yaml.is_a?(Hash) then
        return yaml
      else
        raise "Invalid config.#{extension} data."
      end
    else
      raise "Missing config.#{extension} file."
    end
  end

  def self.migrate_server(s)
    {
      'hostname'    => s[1].to_s,
      'user'        => 'root',
      'port'        => 22,
      'deploy_path' => '/var/crypti',
      'crypti_path' => '/install',
      'accounts'    => @config_bak['accounts'][s[0].to_i].to_a
    }
  end

  def self.migrate_servers
    @config_yml['servers'] = @config_bak['servers'].collect do |s|
      [s[0].to_i, self.migrate_server(s)]
    end.to_h
    @config_yml.delete('accounts')
  end

  def self.update_servers
    return unless @config_bak['servers'].is_a?(Hash)

    if @config_bak['accounts'].is_a?(Hash) then
      migrate_servers
    else
      @config_yml['servers'] = @config_bak['servers']
    end
  end

  def self.run
    @config_bak = self.load_config('bak')
    @config_yml = self.load_config('yml')

    update_servers

    File.open('config.yml', 'w') do |f|
      f.write @config_yml.to_yaml
    end
  end
end

ConfigUpdater.run
