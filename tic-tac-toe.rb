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

class Computer < Player
  def throw(board, human_mark)
    board.place_mark(mark, board.choose_location(mark, human_mark))
    sleep 1
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

  def choose_location(computer_mark, human_mark)
    check_rows_computer(computer_mark, human_mark)
    check_columns_computer(computer_mark, human_mark)
    # check_diagonals_computer
  end

  def check_rows_computer(computer_mark, human_mark)
    grid.each do |row, columns|
      array = []
      columns.each { |column| array << column }

      next if array.any?  { |mark| mark == computer_mark }
      next if array.none? { |mark| mark == human_mark }

      column = array.index("-") + 1
      return "#{row}#{column}"
    end

    choose_random_location
  end

  def check_columns_computer(computer_mark, human_mark)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      grid.each_key do |row|
        array << grid[row][column]
      end

      next if array.any?  { |mark| mark == computer_mark }
      next if array.none? { |mark| mark == human_mark }

      row = rows[array.index("-")]
      return "#{row}#{column + 1}"
    end

    choose_random_location
  end

  def choose_random_location
    rows     = ["a", "b", "c"]
    columns  = [0, 1, 2]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = grid[row.to_sym][column]
      return "#{row}#{column + 1}" if location == "-"
    end
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
    @computer = Computer.new("Computer", "O")
    @board    = Board.new
  end

  def start
    loop do
      board.print_board
      puts "Introduce a position:"
      input = STDIN.gets.chomp
      human.throw(input, board)
      board.check_for_winner(human)
      computer.throw(board, human.mark)
      board.check_for_winner(computer)
    end
  end
end

game = Game.new
game.start
