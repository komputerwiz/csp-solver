require 'csp'

class Mathdoku < CSP
  def initialize(n)
    super()

    cols = ('A'..('A'.ord+n-1).chr).to_a
    rows = (1..n).to_a

    vars cols.product(rows).map(&:join).map(&:to_sym), 1..n

    cols.each do |c|
      all_different(rows.map {|r| "#{c}#{r}".to_sym})
    end

    rows.each do |r|
      all_different(cols.map {|c| "#{c}#{r}".to_sym})
    end
  end

  def sum(value, *vars)
    constrain(*vars) { |*args| args.inject(:+) == value }
  end

  def difference(value, *vars)
    raise ArgumentError, 'Only two vars are allowed' unless vars.size == 2
    constrain(*vars) { |a,b| a-b == value or b-a == value }
  end

  def product(value, *vars)
    constrain(*vars) { |*args| args.inject(:*) == value }
  end

  def quotient(value, *vars)
    raise ArgumentError, 'Only two vars are allowed' unless vars.size == 2
    constrain(*vars) { |a,b| a.fdiv(b) == value or b.fdiv(a) == value }
  end

  def print!(solution)
    rows.each do |r|
      cols.each do |c|
        print solution["#{c}#{r}".to_sym] + ' '
      end
      print "\n"
    end
  end
end
