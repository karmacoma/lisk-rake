require 'loading_status'
require 'account_balance'
require 'mining_info'

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
    @json[key.to_s].size > 1
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

  def forging_status
    if has_section?('forging_status') then
      ForgingStatus.new(@json['forging_status']).to_s
    end
  end

  def mining_info
    if has_section?('mining_info') then
      MiningInfo.new(@json['mining_info'], @cache['mining_info']).to_s
    end
  end

  def account_balance
    if has_section?('account_balance') then
      AccountBalance.new(@json['account_balance'], @cache['account_balance']).to_s
    end
  end

  def to_s
    status = [divider, info, divider, loading_status, sync_status, forging_status, mining_info, account_balance]
    return "" if status.compact.size <= 3
    status.join.to_s
  end
end
