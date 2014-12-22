module CryptiKit
  class ReportSummary
    def initialize(report, cache)
      @report = report
      @cache  = cache
    end

    def divider(char = '-')
      char * 80 + "\n"
    end

    def title
      blue("Report Summary\n")
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

    def total_effective
      if @report.total_effective > 0.0 then
        change = BalanceChange.new(@report.total_effective, @cache.total_effective)
        [sprintf("%-19s", 'Total Effective:'), @report.total_effective, change.to_s, "\n"]
      end
    end

    def not_loaded
      nodes = @report.not_loaded
      if nodes.any? then
        "* #{nodes.size} / #{@report.total_nodes} nodes are not loaded.\n" +
        "> Affected Nodes: " + affected_nodes(nodes) + "\n" + divider
      end
    end

    def syncing
      nodes = @report.syncing
      if nodes.any? then
        "* #{nodes.size} / #{@report.total_nodes} nodes are being synchronised.\n" +
        "> Affected Nodes: " + affected_nodes(nodes) + "\n" + divider
      end
    end

    def not_forging
      nodes = @report.not_forging
      if nodes.any? then
        "* #{nodes.size} / #{@report.total_nodes} nodes are not forging.\n" +
        "> Affected Nodes: " + affected_nodes(nodes) + "\n" + divider
      end
    end

    def baddies
      nodes = @report.baddies
      if nodes.any? then
        baddies =  red("* #{nodes.size} nodes encountered errors and were not checked.\n\n")
        baddies << red("Error Messages:\n")
        nodes.each { |node| baddies << red("* Node[#{node['key']}] #{node['error']}\n") }
        baddies << divider
        baddies
      end
    end

    def node_pointer(node)
      " -> Node[#{node['key']}]"
    end

    def lowest_effective
      if node = @report.lowest_effective then
        [sprintf("%-19s", 'Lowest Balance:'), node['effectiveBalance'].to_xcr, node_pointer(node), "\n"]
      end
    end

    def highest_effective
      if node = @report.highest_effective then
        [sprintf("%-19s", 'Highest Balance:'), node['effectiveBalance'].to_xcr, node_pointer(node), "\n"]
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
        total_effective,
        lowest_effective,
        highest_effective,
        divider,
        not_loaded,
        syncing,
        not_forging,
        baddies
      ].join.to_s
    end

    private

    def affected_nodes(nodes)
      nodes.collect { |n| n['key'] }.join(',')
    end
  end
end
