module Hypercuke
  module MiniInflector
    extend self

    def camelize(name)
      name.to_s.split('_').map(&:capitalize).join
    end

    def constantize(name, scope)
      const_name = camelize(name)
      scope.const_get(const_name)
    end
  end
end
