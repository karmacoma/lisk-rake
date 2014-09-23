require 'lib/loading_status'
require 'lib/forging_status'
require 'lib/account_balance'
require 'lib/mining_info'

class NodeStatus
  def initialize(json)
    @json = json
  end

  def divider
    "=" * 80 + "\n"
  end

  def info
    @json['info'] + "\n"
  end

  def loading_status
    if @json['loading_status'].size > 1 then
      LoadingStatus.new(@json['loading_status']).to_s
    end
  end

  def forging_status
    if @json['forging_status'].size > 1 then
      ForgingStatus.new(@json['forging_status']).to_s
    end
  end

  def mining_info
    if @json['mining_info'].size > 1 then
      MiningInfo.new(@json['mining_info']).to_s
    end
  end

  def account_balance
    if @json['account_balance'].size > 1 then
      AccountBalance.new(@json['account_balance']).to_s
    end
  end

  def to_s
    status = [divider, info, divider, loading_status, forging_status, mining_info, account_balance]
    return "" if status.compact.size <= 3
    status.join.to_s
  end
end