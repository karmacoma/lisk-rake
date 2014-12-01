require 'yaml'

class List
  def initialize
    @items = CryptiKit.config[self.class.key] || {}
  end

  def all
    @items
  end

  def keys
    @items.keys
  end

  def values
    @items.values
  end

  def [](key)
    @items[key]
  end

  def []=(key, item)
    @items[key] = item
  end

  def add(item)
    return if @items.values.include?(item.to_s)
    key = (@items.size > 0) ? @items.keys.last + 1 : 1
    @items[key] = item.to_s
  end

  def add_all(items)
    _items = items.is_a?(Array) ? items : self.class.parse_values(items)
    _items.each { |item| add(item) }
  end

  def remove(key)
    @items.delete(key.to_i)
  end

  def remove_all(items)
    _items = items.is_a?(Array) ? items : self.class.parse_keys(items)
    _items.each { |item| remove(item) }
  end

  def before_save; end

  def save
    before_save
    File.open('config.yml', 'w') do |f|
      CryptiKit.config[self.class.key] = self.class.reindex ? reindexed : sorted
      f.write CryptiKit.config.to_yaml
    end
  end

  def sorted
    @items.sort_by { |k,v| k }.to_h
  end

  def reindexed
    key    = 0
    _items = {}
    sorted.values.each { |item| _items[(key += 1)] = item }
    _items
  end

  class << self
    attr_reader :key, :key_regexp, :value_regexp, :reindex
  end

  @key          = 'items'
  @key_regexp   = /^0-9,/
  @value_regexp = /[^,]+/
  @reindex      = true

  def self.parse_keys(keys)
    keys.to_s.gsub(key_regexp, '').split(',')
  end

  def self.parse_values(values)
    values.to_s.gsub(value_regexp, '').split(',')
  end
end
