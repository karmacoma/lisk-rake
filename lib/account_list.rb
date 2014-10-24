require 'list'

class AccountList < List
  def []=(key, item)
    if item.is_a?(Hash) then
      @items[key] = { 'address' => item['address'], 'public_key' => item['publickey'] }
    end
  end

  @key          = 'accounts'
  @key_regexp   = List.key_regexp
  @value_regexp = /[^0-9A-Z,\.]+/
  @reindex      = false
end
