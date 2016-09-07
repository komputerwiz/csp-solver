require 'csp/solver/version'
require 'securerandom'

module CSP
  module Solver
    class Problem
      def initialize
        @vars = {}
        @gen_prefix = '__gen__'

        @unary_constraints = Hash.new { |h, k| h[k] = [] }
        @binary_constraints = Hash.new { |h, k| h[k] = [] }
      end

      def var(id, domain)
        @vars[id] = domain.to_a
      end

      def assign(hash)
        hash.each { |x, v| @vars[x] = [v] }
      end

      def vars(ids, domain)
        ids.each { |id| var(id, domain.dup) }
      end

      def constrain(*vars, &pred)
        case vars.length
        when 1
          unary_constrain(vars[0], &pred)
        when 2
          binary_constrain(vars[0], vars[1], &pred)
        else
          nary_constrain(vars, &pred)
        end
      end

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

      # backtracking algorithm with interleaved local constraint propagation
      def solve(domains = @vars)
        # deep-copy domains to prevent changes from "leaking" to outside
        domains = domains.each_with_object({}) { |(k, v), ds| ds[k] = v.dup; ds }

        return false unless ac3(domains)

        if domains.values.all? { |dom| dom.size == 1 }
          return domains.each_with_object({}) do |(k, v), sol|
            sol[k] = v[0] unless k.is_a?(String) && k.start_with?(@gen_prefix)
            sol
          end
        end

        var = domains.select { |_var, dom| dom.size > 1 }.keys.sort_by { |k| domains[k].size }.first
        dom = domains[var]

        dom.each do |value|
          domains[var] = [value]

          result = solve(domains)
          return result if result
        end

        domains[var] = dom

        false
      end

      private

      def ac3(vars)
        vars.each do |var, domain|
          next unless @unary_constraints.key? var
          domain.reject! { |x| !@unary_constraints[var].all? { |c| c.call(x) } }
          return false if domain.empty?
        end

        worklist = @binary_constraints.keys

        until worklist.empty?
          x, y = worklist.shift
          reduced_domain = vars[x].reject! { |vx| !vars[y].any? { |vy| @binary_constraints[[x, y]].all? { |c| c.call(vx, vy) } } }
          unless reduced_domain.nil?
            return false if vars[x].empty?
            worklist |= @binary_constraints.keys.select { |k| k.include?(x) && !k.include?(y) }
          end
        end

        true
      end

      def unary_constrain(x, &pred)
        raise "No variable #{x}" unless @vars.key? x

        @unary_constraints[x] << pred
      end

      def binary_constrain(x1, x2, &pred)
        raise "No variable #{x1}" unless @vars.key? x1
        raise "No variable #{x2}" unless @vars.key? x2

        @binary_constraints[[x1, x2]] << pred

        # note the swapped parameter order
        @binary_constraints[[x2, x1]] << proc { |v2, v1| yield(v1, v2) }
      end

      def nary_constrain(vars)
        vars.each do |x|
          raise "No variable #{x}" unless @vars.key? x
        end

        # Reduce n-way constraint to binary constraints:
        # Generate auxiliary variable to serve as binary intermediary between all constrained variables.
        # This variable's full domain is the cartesian product of all constrained variables' domains,
        # but here we filter the domain to only the values that satisfy the constraint.
        head, *tail = vars.map { |x| @vars[x] }
        dom = head.product(*tail).select { |tuple| yield(*tuple) }
        gen_id = @gen_prefix + SecureRandom.uuid

        var(gen_id, dom)

        vars.each_with_index do |x, i|
          binary_constrain(x, gen_id) { |v, tuple| v == tuple[i] }
        end
      end
    end
  end
end
