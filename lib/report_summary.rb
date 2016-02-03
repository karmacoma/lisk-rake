module LiskRake
  class ReportSummary
    def initialize(report, cache)
      @report = report
      @cache  = cache
    end

    def divider(char = '-')
      char * 80 + "\n"
    end

    def title
      Color.light_blue("Report Summary\n")
    end

    def total_forged
      if @report.total_forged > 0.0 then
        change = BalanceChange.new(@report.total_forged, @cache.total_forged)
        [sprintf("%-19s", 'Total Forged:'), @report.total_forged, change.to_s, "\n"]
      end
    end

    def total_checked
      [sprintf("%-19s", 'Nodes Checked:'), @report.total_checked, "\n"]
    end

    def total_balance
      if @report.total_balance > 0.0 then
        change = BalanceChange.new(@report.total_balance, @cache.total_balance)
        [sprintf("%-19s", 'Total Balance:'), @report.total_balance, change.to_s, "\n"]
      end
    end

    def total_unconfirmed
      if @report.total_unconfirmed > 0.0 then
        change = BalanceChange.new(@report.total_unconfirmed, @cache.total_unconfirmed)
        [sprintf("%-19s", 'Total Unconfirmed:'), @report.total_unconfirmed, change.to_s, "\n"]
      end
    end

    def not_loaded
      nodes = @report.not_loaded
      if nodes.any? then
        ["* #{nodes.size} / #{@report.total_nodes} nodes are not loaded.\n",
         "> Affected Nodes: #{affected_nodes(nodes)}\n",
         divider]
      end
    end

    def syncing
      nodes = @report.syncing
      if nodes.any? then
        ["* #{nodes.size} / #{@report.total_nodes} nodes are being synchronised.\n",
         "> Affected Nodes: #{affected_nodes(nodes)}\n",
         divider]
      end
    end

    def on_standby
      accounts = @report.on_standby
      if accounts.any? then
        ["* #{accounts.size} / #{@report.total_accounts} delegates are on standby.\n" +
         "> Affected Delegates: #{affected_accounts(accounts)}\n",
         divider]
      end
    end

    def not_forging
      accounts = @report.not_forging
      if accounts.any? then
        ["* #{accounts.size} / #{@report.total_accounts} delegates are not forging.\n" +
         "> Affected Delegates: #{affected_accounts(accounts)}\n",
         divider]
      end
    end

    def outdated
      nodes = @report.outdated
      if nodes.any? then
        ["* #{nodes.size} / #{@report.total_nodes} nodes are outdated.\n",
         "> Affected Nodes: #{affected_nodes(nodes)}\n\n",
         Color.green("Version: #{ReferenceNode.version} is now available.\n\n"),
         "Please run the folowing command to upgrade them:\n",
         Color.light_blue("$ rake reinstall_nodes servers=#{affected_nodes(nodes)}\n"),
         divider]
      end
    end

    def baddies
      nodes = @report.baddies
      if nodes.any? then
        [Color.red("* #{nodes.size} nodes encountered errors and were not checked.\n\n"),
         Color.red("Error Messages:\n"),
         nodes.collect { |node| Color.red("* Node[#{node['key']}] #{node['error']}\n") },
         divider]
      end
    end

    def node_username(json)
      key      = Color.green(json['key'].to_s)
      username = Color.light_blue(json['username'])
      " -> Node[#{key}](#{username})"
    end

    def lowest_balance
      if lowest = @report.lowest_balance then
        [sprintf("%-19s", 'Lowest Balance:'), lowest['balance'].to_lisk, node_username(lowest), "\n"]
      end
    end

    def highest_balance
      if highest = @report.highest_balance then
        [sprintf("%-19s", 'Highest Balance:'), highest['balance'].to_lisk, node_username(highest), "\n"]
      end
    end

    def generated_at
      [sprintf("%-19s", 'Generated:'), @report.generated_at, "\n"]
    end

    def last_generated_at
      [sprintf("%-19s", 'Last Generated:'), @cache.generated_at, "\n"]
    end

    def to_s
      [
        divider('='),
        title,
        divider('='),
        total_checked,
        generated_at,
        last_generated_at,
        total_forged,
        total_balance,
        total_unconfirmed,
        lowest_balance,
        highest_balance,
        divider,
        not_loaded,
        syncing,
        on_standby,
        not_forging,
        outdated,
        baddies
      ].join.to_s
    end

    private

    def affected_nodes(nodes)
      nodes.collect { |n| n['key'] }.join(',')
    end

    def affected_accounts(accounts)
      accounts.collect do |a|
        delegate_status = a['delegate_status']
        key      = Color.green(delegate_status['key'].to_s)
        username = Color.light_blue(delegate_status['username'])
        "Node[#{key}](#{username})"
      end.join(',')
    end
  end
end
