require 'lib/loading_status'
require 'lib/forging_status'
require 'lib/account_balance'

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
    LoadingStatus.new(@json['loading_status']).to_s
  end

  def forging_status
    ForgingStatus.new(@json['forging_status']).to_s
  end

  def account_balance
    AccountBalance.new(@json['account_balance']).to_s
  end

  def to_s
    [divider, info, divider, loading_status, forging_status, account_balance].join.to_s
  end
end