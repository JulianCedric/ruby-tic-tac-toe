# Project: Tic-tac-toe in Ruby for The Odin Project
# Author: Luján Fernaud
#
# Instructions:
#
# Build a tic-tac-toe game on the command line where two human players can play
# against each other and the board is displayed in between turns.
#
# Wikipedia: https://en.wikipedia.org/wiki/Tic-tac-toe

require 'pry'

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

  def check_for_winner(last_player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)
  end

  def check_rows(last_player)
    grid.each_value do |row|
      the_winner_is(last_player) if row.all? { |mark| mark == last_player.mark }
    end
  end

  def check_columns(last_player)
    array = []

    3.times do |column|
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
      end

      break if array.length == 3
      array = []
      column += 1
    end

    the_winner_is(last_player) if array.length == 3 && array.all?
  end

  def check_diagonals(last_player)
    array = []

    3.times do |column|
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
        column += 1
      end

      break if array.length == 3
      array = []
    end

    if array.length < 3
      array = []

      3.times do |column|
        grid.map { |key, _value| key }.reverse.each do |row|
          array << true if grid[row][column] == last_player.mark
          column += 1
        end

        break if array.length == 3
        array = []
      end
    end

    the_winner_is(last_player) if array.length == 3 && array.all?
  end

  def the_winner_is(last_player)
    puts " #{last_player.name} wins!\n\n"
    exit
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

class Game
  attr_reader :human, :computer, :board

  def initialize
    @human    = Player.new("Human", "X")
    @computer = Player.new("Computer", "O")
    @board    = Board.new
  end

  def start
    loop do
      board.print_board
      puts "Introduce a position:"
      input = STDIN.gets.chomp
      human.throw(input, board)
      board.check_for_winner(human)
    end
  end
end

game = Game.new
game.start
