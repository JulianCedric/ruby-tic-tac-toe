# Project: Tic-tac-toe in Ruby for The Odin Project
# Author: Luján Fernaud
#
# Instructions:
#
# Build a tic-tac-toe game on the command line where two human players can play
# against each other and the board is displayed in between turns.
#
# Wikipedia: https://en.wikipedia.org/wiki/Tic-tac-toe

class Board
  attr_accessor :grid

  def initialize
    @grid = { a: ['-', '-', '-'],
              b: ['-', '-', '-'],
              c: ['-', '-', '-'] }
  end

  def place_mark(mark, coordinates)
    return slot_not_available(coordinates) unless slot_available(coordinates)
    grid[letter(coordinates)][number(coordinates)] = mark
    print_board
  end

  def slot_available(coordinates)
    grid[letter(coordinates)][number(coordinates)] == "-"
  end

  def slot_not_available(coordinates)
    print_board
    puts "The position '#{coordinates}' is already taken."
    puts "\n"
  end

  def letter(coordinates)
    coordinates[0].to_sym
  end

  def number(coordinates)
    coordinates[1].to_i - 1
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    puts "     1 | 2 | 3 "
    puts "   ------------"
    puts " a | #{grid[:a][0]}   #{grid[:a][1]}   #{grid[:a][2]}"
    puts "   ------------"
    puts " b | #{grid[:b][0]}   #{grid[:b][1]}   #{grid[:b][2]}"
    puts "   ------------"
    puts " c | #{grid[:c][0]}   #{grid[:c][1]}   #{grid[:c][2]}"
    puts "\n"
  end
end

class Player
  attr_reader :name, :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

  def throw(coordinates, board)
    board.place_mark(mark, coordinates)
  end
end

board = Board.new
player1 = Player.new("Player 1", "X")

board.print_board

loop do
  puts "Introduce a position:"
  input = STDIN.gets.chomp
  player1.throw(input, board)
end
