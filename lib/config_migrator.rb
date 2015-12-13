module CryptiKit
  class ConfigMigrator
    def initialize(task, node)
      @task = task
      @node = node
    end

    def migrate(&block)
      _old = ConfigInspector.inspect(@task, @node)
      yield
      _new = ConfigInspector.inspect(@task, @node)
      _new['forging'] = _old['forging'] if _old['forging'].is_a?(Hash)
      ConfigUpdater.update(@task, @node, _new)
    end

    def self.migrate(task, node, &block)
      self.new(task, node).migrate(&block)
    end
  end
end
