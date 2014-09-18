class AccountList < List
  @key          = 'accounts'
  @key_regexp   = List.key_regexp
  @value_regexp = /[^0-9A-Z,\.]+/
end
