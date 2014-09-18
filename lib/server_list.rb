class ServerList < List
  @key          = 'servers'
  @key_regexp   = List.key_regexp
  @value_regexp = /[^0-9,\.]+/
end
