module LiskRake
  class NodeStatus
    def initialize(json, cache)
      @json  = json
      @cache = cache || {}
    end

    def divider(char = '=')
      char * 80 + "\n"
    end

    def info
      @json['info'] + "\n"
    end

    def loaded?
      @json['loading_status'] and @json['loading_status']['loaded'] == true
    end

    def has_section?(key, json = nil)
      if json.nil? then
        json = @json
      end
      val = json[key.to_s]
      val.is_a?(Hash) and val['success']
    end

    def process_status
      if has_section?('process_status') then
        ProcessStatus.new(@json['process_status']).to_s
      end
    end

    def config_status
      if has_section?('config_status') then
        ConfigStatus.new(@json['config_status']).to_s
      end
    end

    def loading_status
      if has_section?('loading_status') then
        LoadingStatus.new(@json['loading_status']).to_s
      end
    end

    def sync_status
      if has_section?('sync_status') then
        SyncStatus.new(@json['sync_status']).to_s
      end
    end

    def block_status
      if has_section?('block_status') then
        BlockStatus.new(@json['block_status']).to_s
      end
    end

    def accounts_status
      if has_section?('accounts_status') then
        accounts = []
        @json['accounts_status']['accounts'].each_with_index do |json,i|
          cache = @cache['accounts_status']['accounts'][i] rescue nil
          cache = {} if cache.nil?
          next unless loaded?
          accounts.push([
            divider('-'),
            delegate_status(json),
            forging_status(json),
            forging_info(json, cache),
            account_balance(json, cache)
          ])
        end
        accounts
      end
    end

    def to_s
      status = [
        divider,
        info,
        divider,
        process_status,
        config_status,
        loading_status,
        sync_status,
        block_status,
        accounts_status
      ]
      return '' if status.compact.size <= 3
      status.join.to_s
    end

    private

    def delegate_status(json)
      if has_section?('delegate_status', json) then
        DelegateStatus.new(json['delegate_status']).to_s
      end
    end

    def forging_status(json)
      if has_section?('forging_status', json) then
        ForgingStatus.new(json['forging_status']).to_s
      end
    end

    def forging_info(json, cache)
      if has_section?('forging_info', json) then
        ForgingInfo.new(json['forging_info'], cache['forging_info']).to_s
      end
    end

    def account_balance(json, cache)
      if has_section?('account_balance', json) then
        AccountBalance.new(json['account_balance'], cache['account_balance']).to_s
      end
    end
  end
end
