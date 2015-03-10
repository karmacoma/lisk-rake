#!/usr/bin/env ruby

require 'yaml'

file_a = File.join(Dir.pwd, 'config.bak')

if File.exist?(file_a) then
  config_bak = YAML.load_file(file_a)
end

file_b = File.join(Dir.pwd, 'config.yml')

if File.exist?(file_b) then
  config_yml = YAML.load_file(file_b)
end

if config_bak.is_a?(Hash) and config_yml.is_a?(Hash) then
  ['servers', 'accounts'].each do |k|
    config_yml[k] = config_bak[k]
  end

  File.open('config.yml', 'w') do |f|
    f.write config_yml.to_yaml
  end
end
