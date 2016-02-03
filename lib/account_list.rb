module LiskRake
  class AccountList
    def initialize(node)
      @node  = node
      @list  = ServerList.new
      @items = @list[@node.key]['accounts'] rescue []
    end

    def add(item)
      if item.is_a?(Hash) then
        account = {
          'address'    => item['address'],
          'public_key' => item['publicKey']
        }
        unless find_index(item['address']) then
          @items.push(account)
        end
      end
    end

    def remove(item)
      if item.is_a?(Hash) then
        index = find_index(item['address'])
        @items.delete_at(index) unless index.nil?
      end
    end

    def self.remove_all(node)
      list = self.new(node)
      list.clear
      list.save
    end

    def find_index(address)
      @items.find_index do |a|
        a['address'] == address
      end
    end

    def clear
      @items.clear
    end

    def save
      @list.save
    end
  end
end
