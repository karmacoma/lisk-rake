require 'list'

class ServerList < List
  @key          = 'servers'
  @key_regexp   = List.key_regexp
  @value_regexp = /[^0-9,\.]+/
  @reindex      = true

  def before_save
    CryptiKit.config['accounts'].keys.each do |key|
      CryptiKit.config['accounts'].delete(key) if !@items[key]
    end
  end
end
