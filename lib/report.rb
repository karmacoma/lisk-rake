module CryptiKit
  class Report
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

    def baddies=(baddies)
      @baddies = baddies
    end

    def baddies
      @baddies ||= []
    end

    def outdated
      @nodes.collect { |k,v| v['config_status'] }.find_all do |n|
        n['outdated']
      end
    end

    def not_loaded
      @nodes.collect { |k,v| v['loading_status'] }.find_all do |n|
        !n['loaded']
      end
    end

    def syncing
      @nodes.collect { |k,v| v['sync_status'] }.find_all do |n|
        n['sync']
      end
    end

    def not_forging
      @nodes.collect { |k,v| v['forging_status'] }.find_all do |n|
        !n['enabled']
      end
    end

    def total_nodes
      @nodes.size
    end

    def total_configured
      Core.config['servers'].size
    end

    def total_checked
      "#{total_nodes} / #{total_configured} Configured"
    end

    def generated_at
      @generated_at ||= Time.now.to_s
    end

    attr_writer :generated_at

    def total_forged
      total_balance('sum', 'mining_info')
    end

    def total_balance(type = 'balance', parent = 'account_balance')
      balance = 0.0
      @nodes.collect { |k,v| v[parent.to_s] }.collect do |n|
        balance += n[type.to_s].to_f
      end
      balance.to_xcr
    end

    def total_unconfirmed
      total_balance('unconfirmedBalance')
    end

    def lowest_balance
      @nodes.collect do |k,v|
        v['account_balance'] if v['account_balance']['balance']
      end.compact.min do |a,b|
        a['balance'] <=> b['balance']
      end
    end

    def highest_balance
      @nodes.collect do |k,v|
        v['account_balance'] if v['account_balance']['balance']
      end.compact.max do |a,b|
        a['balance'] <=> b['balance']
      end
    end

    def to_s
      report = String.new
      if @baddies.any? or @nodes.any? then
        @nodes.each_pair do |k,v|
          report << NodeStatus.new(v, cache[k.to_s]).to_s if v.any?
        end
        report << ReportSummary.new(self, cache).to_s
      end
      report
    end

    def self.run(&block)
      report = self.new
      block.call report
      report.baddies = Core.baddies
      puts report.to_s
      report.save
    end

    CACHE_FILE = 'cache.json'

    def cache
      (@cache) ? @cache : load
    end

    def import(array)
      if array.is_a?(Array) then
        @baddies      = array[0] if array[0].is_a?(Array)
        @nodes        = array[1] if array[1].is_a?(Hash)
        @generated_at = array[2] if array[2].is_a?(String)
      end
    end

    def load
      @cache = self.class.new
      if File.exists?(CACHE_FILE) then
        @cache.import(JSON.parse(File.read(CACHE_FILE)))
      else
        @cache.generated_at = 'Never'
      end
      @cache
    end

    def save
      File.open(CACHE_FILE, 'w') do |f|
        f.puts [@baddies, @nodes, @generated_at].to_json
      end
    end
  end
end
