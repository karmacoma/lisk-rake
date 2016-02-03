module LiskRake
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

    def accounts
      if @accounts.nil? then
        @accounts = []
        @nodes.each_value do |n|
          n['accounts_status']['accounts'].each do |a|
            @accounts.push(a)
          end
        end
      end
      @accounts
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

    def on_standby
      accounts.find_all { |a| a['delegate_status']['delegate']['rate'].to_i > 101 rescue false }
    end

    def not_forging
      accounts.find_all { |a| !a['forging_status']['enabled'] }
    end

    def total_nodes
      @nodes.size
    end

    def total_accounts
      @accounts.size
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
      total_balance('fees', 'forging_info')
    end

    def total_balance(type = 'balance', parent = 'account_balance')
      balance = 0.0
      accounts.each do |a|
        balance += a[parent.to_s][type.to_s].to_f
      end
      balance.to_lisk
    end

    def total_unconfirmed
      total_balance('unconfirmedBalance')
    end

    def lowest_balance
      accounts.collect do |v|
        v['account_balance'] if v['account_balance']['balance']
      end.compact.min do |a,b|
        a['balance'] <=> b['balance']
      end
    end

    def highest_balance
      accounts.collect do |v|
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
