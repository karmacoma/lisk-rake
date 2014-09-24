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

  def total_forged
    if @report.total_forged > 0.0 then
      [sprintf("%-19s", 'Total Forged:'), balance(@report.total_forged), "\n"]
    end
  end

  def total_checked
    [sprintf("%-19s", 'Nodes Checked:'), @report.total_checked, "\n"]
  end

  def total_balance
    if @report.total_balance > 0.0 then
      [sprintf("%-19s", 'Total Balance:'), balance(@report.total_balance), "\n"]
    end
  end

  def total_unconfirmed
    if @report.total_unconfirmed > 0.0 then
      [sprintf("%-19s", 'Total Unconfirmed:'), balance(@report.total_unconfirmed), "\n"]
    end
  end

  def total_effective
    if @report.total_effective > 0.0 then
      [sprintf("%-19s", 'Total Effective:'), balance(@report.total_effective), "\n"]
    end
  end

  def not_loaded
    nodes = @report.not_loaded
    if nodes.any? then
      "* #{nodes.size} / #{@report.total_nodes} nodes are not loaded properly.\n" +
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

  def baddies
    nodes = @report.baddies
    if nodes.any? then
      baddies =  "* #{nodes.size} nodes encountered errors and were not checked.\n\n"
      baddies << "Error Messages:\n"
      nodes.each { |node| baddies << "* Node[#{node['key']}] #{node['error']}\n" }
      baddies << divider
      baddies
    end
  end

  def node_key(node)
    " -> Node[#{node['key']}]"
  end

  def lowest_effective
    if node = @report.lowest_effective then
      [sprintf("%-19s", 'Lowest Balance:'), balance(node['effectiveBalance']), node_key(node), "\n"]
    end
  end

  def highest_effective
    if node = @report.highest_effective then
      [sprintf("%-19s", 'Highest Balance:'), balance(node['effectiveBalance']), node_key(node), "\n"]
    end
  end

  def to_s
    [
      divider('='),
      title,
      divider('='),
      total_checked,
      total_forged,
      total_balance,
      total_unconfirmed,
      total_effective,
      lowest_effective,
      highest_effective,
      divider,
      not_loaded,
      not_forging,
      baddies
    ].join.to_s
  end
end