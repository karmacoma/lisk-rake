require 'list'

module CryptiKit
  class AccountList < List
    def []=(key, item)
      key = key.to_i
      if item.is_a?(Hash) then
        account = {
          'address'    => item['address'],
          'public_key' => item['publicKey']
        }
        @items[key] ||= []
        if find_index(key, item['address']).nil? then
          @items[key].push(account)
        end
      end
    end

    def remove(key, item)
      key = key.to_i
      if item.is_a?(Hash) then
        index = find_index(key, item['address'])
        @items[key].delete_at(index) unless index.nil?
      else
        @items.delete(key)
      end
    end

    def find_index(key, address)
      if key and address then
        @items[key.to_i].find_index do |a|
          a['address'].to_s == address.to_s
        end
      end
    end

    @key          = 'accounts'
    @key_regexp   = List.key_regexp
    @value_regexp = /[^0-9A-Z,\.]+/
    @reindex      = false
  end
end
