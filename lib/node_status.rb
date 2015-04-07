module CryptiKit
  class NodeStatus
    def initialize(json, cache)
      @json  = json
      @cache = cache || {}
    end

    def divider
      "=" * 80 + "\n"
    end

    def info
      @json['info'] + "\n"
    end

    def has_section?(key)
      val = @json[key.to_s]
      val.is_a?(Hash) and val['success']
    end

    def forever_status
      if has_section?('forever_status') then
        ForeverStatus.new(@json['forever_status']).to_s
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

    def delegate_status
      if has_section?('delegate_status') then
        DelegateStatus.new(@json['delegate_status']).to_s
      end
    end

    def forging_status
      if has_section?('forging_status') then
        ForgingStatus.new(@json['forging_status']).to_s
      end
    end

    def forging_info
      if has_section?('forging_info') then
        ForgingInfo.new(@json['forging_info'], @cache['forging_info']).to_s
      end
    end

    def account_balance
      if has_section?('account_balance') then
        AccountBalance.new(@json['account_balance'], @cache['account_balance']).to_s
      end
    end

    def to_s
      status = [divider, info, divider, forever_status, config_status, loading_status, sync_status, block_status, delegate_status, forging_status, forging_info, account_balance]
      return "" if status.compact.size <= 3
      status.join.to_s
    end
  end
end
