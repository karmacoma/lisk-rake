class ReportSummary
  def initialize(report)
    @report = report
  end

  def divider(char = '-')
    char * 80 + "\n"
  end

  def title
    "Report Summary\n"
  end

  def balance(balance)
    balance.to_f / 10**8
  end

  def total_checked
    [sprintf("%-19s", 'Nodes Checked:'), @report.total_checked, "\n"]
  end

  def total_balance
    [sprintf("%-19s", 'Total Balance:'), balance(@report.total_balance), "\n"]
  end

  def total_unconfirmed
    [sprintf("%-19s", 'Total Unconfirmed:'), balance(@report.total_unconfirmed), "\n"]
  end

  def total_effective
    [sprintf("%-19s", 'Total Effective:'), balance(@report.total_effective), "\n"]
  end

  def not_loaded
    nodes = @report.not_loaded
    if nodes.any? then
      "* #{nodes.size} / #{@report.total_nodes} nodes are not fully loaded.\n" +
      "> Affected Nodes: " + @report.affected_nodes(nodes).join(',') + "\n" + divider
    end
  end

  def not_forging
    nodes = @report.not_forging
    if nodes.any? then
      "* #{nodes.size} / #{@report.total_nodes} nodes are not currently forging.\n" +
      "> Affected Nodes: " + @report.affected_nodes(nodes).join(',') + "\n" + divider
    end
  end

  def node_key(node)
    " -> Node[#{node['key']}]"
  end

  def lowest_effective
    node = @report.lowest_effective
    [sprintf("%-19s", 'Lowest Balance:'), balance(node['effectiveBalance']), node_key(node), "\n"]
  end

  def highest_effective
    node = @report.highest_effective
    [sprintf("%-19s", 'Highest Balance:'), balance(node['effectiveBalance']), node_key(node), "\n"]
  end

  def to_s
    [
      divider('='),
      title,
      divider('='),
      total_checked,
      total_balance,
      total_unconfirmed,
      total_effective,
      lowest_effective,
      highest_effective,
      divider,
      not_loaded,
      not_forging
    ].join.to_s
  end
end