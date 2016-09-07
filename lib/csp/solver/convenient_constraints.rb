module CSP
  module Solver
    # These methods are convenience methods to allow you
    # to set common constraints (predicates) on your Problem.
    module ConvenientConstraints
      def all_pairs(vars, &block)
        pairs = vars.repeated_combination(2).reject { |x, y| x == y }
        pairs.each { |x, y| constrain(x, y, &block) }
      end

      def all_same(vars)
        all_pairs(vars) { |x, y| x == y }
      end

      def all_different(vars)
        all_pairs(vars) { |x, y| x != y }
      end
    end
  end
end
