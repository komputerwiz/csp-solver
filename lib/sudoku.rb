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



s = Sudoku.new(3)

s.assign({
  :A1 => 8,
  :C2 => 3,
  :D2 => 6,
  :B3 => 7,
  :E3 => 9,
  :G3 => 2,
  :B4 => 5,
  :F4 => 7,
  :E5 => 4,
  :F5 => 5,
  :G5 => 7,
  :D6 => 1,
  :H6 => 3,
  :C7 => 1,
  :H7 => 6,
  :I7 => 8,
  :C8 => 8,
  :D8 => 5,
  :H8 => 1,
  :B9 => 9,
  :G9 => 4
})

solution = s.solve

if solution
  s.print! solution
else
  print "no solution"
end
