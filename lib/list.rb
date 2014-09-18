class List
  def initialize(config)
    @config = config                 || {}
    @items  = config[self.class.key] || {}
  end

  def all
    @items
  end

  def [](key)
    @items[key]
  end

  def []=(key, item)
    @items[key] = item
  end

  def add(item)
    return if @items.values.include?(item.to_s)
    key = (@items.size > 0) ? @items.keys.last + 1 : 0
    @items[key] = item.to_s
  end

  def add_all(items)
    _items = self.class.parse_values(items)
    _items.each { |item| add(item) }
  end

  def remove(key)
    @items.delete(key)
  end

  def remove_all(items)
    _items = self.class.parse_keys(items)
    _items.each { |item| remove(item) }
  end

  def save
    File.open('config.yml', 'w') do |f|
      @config[self.class.key] = self.class.reindex ? reindexed : sorted
      f.write @config.to_yaml
    end
  end

  def sorted
    @items.sort_by { |k,v| k }.to_h
  end

  def reindexed
    key    = -1
    _items = {}
    sorted.values.each { |item| _items[(key += 1)] = item }
    _items
  end

  #
  # Class Methods
  #

  class << self
    attr_reader :key, :key_regexp, :value_regexp, :reindex
  end

  @key          = 'items'
  @key_regexp   = /^0-9,/
  @value_regexp = /[^,]+/
  @reindex      = true

  def self.parse_keys(keys)
    keys.gsub(key_regexp, '').split(',')
  end

  def self.parse_values(values)
    values.gsub(value_regexp, '').split(',')
  end
end
