class CryptiReport
  def initialize
    @nodes = {}
  end

  def [](key)
    @nodes[key]
  end

  def []=(key, json)
    if key.is_a?(Integer) and json.is_a?(Hash) then
      @nodes[key] = json
    end
  end

  def to_s
    result = String.new
    @nodes.values.each do |r|
      result << NodeStatus.new(r).to_s if r.any?
    end
    result
  end
end