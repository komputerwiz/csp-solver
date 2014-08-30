$: << File.dirname(__FILE__)
require 'csp'

class Sudoku < CSP
  def initialize(n)
    super()

    size = n*n

    @cols = ('A'..('A'.ord+size-1).chr).to_a
    @rows = (1..size).to_a

    vars @cols.product(@rows).map(&:join).map(&:to_sym), 1..size

    @cols.each do |c|
      all_different @rows.map {|r| "#{c}#{r}".to_sym}
    end

    @rows.each do |r|
      all_different @cols.map {|c| "#{c}#{r}".to_sym}
    end

    @cols.each_slice(n) do |cs|
      @rows.each_slice(n) do |rs|
        all_different cs.product(rs).map(&:join).map(&:to_sym)
      end
    end
  end

  def print!(solution)
    @rows.each do |r|
      @cols.each do |c|
        print solution["#{c}#{r}".to_sym].to_s + ' '
      end
      print "\n"
    end
  end
end
