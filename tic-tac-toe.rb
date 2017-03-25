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
    board.place_mark(self, mark, coordinates)
  end
end

class Computer < Player
  def throw(board, human_mark)
    board.place_mark(self, mark, board.choose_location(mark, human_mark))
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

  def place_mark(player, mark, coordinates)
    return slot_not_available(coordinates, player) unless slot_available(coordinates)

    grid[letter(coordinates)][number(coordinates)] = mark

    print_board
    check_for_winner(player)
  end

  def slot_available(coordinates)
    grid[letter(coordinates)][number(coordinates)] == "-"
  end

  def slot_not_available(coordinates, player)
    print_board
    puts "The position '#{coordinates}' is already taken."
    puts "\n"
    introduce_position(player)
  end

  def letter(coordinates)
    coordinates[0].to_sym
  end

  def number(coordinates)
    coordinates[1].to_i - 1
  end

  def choose_location(computer_mark, human_mark)
    2.times do |iteration|
      match_in_rows = check_rows_computer(computer_mark, human_mark, iteration)
      return match_in_rows if match_in_rows

      match_in_columns = check_columns_computer(computer_mark, human_mark, iteration)
      return match_in_columns if match_in_columns

      match_in_diagonals = check_diagonals_computer(computer_mark, human_mark, iteration)
      return match_in_diagonals if match_in_diagonals
    end

    choose_random_location
  end

  def check_rows_computer(computer_mark, human_mark, iteration)
    grid.each do |row, columns|
      array = []
      columns.each { |column| array << column }

      computer_marks = array.join.count(computer_mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      next if array.any?  { |mark| mark == computer_mark }
      next if array.none? { |mark| mark == human_mark }
      break if iteration.zero? && human_marks != 2

      column = array.index("-") + 1
      return "#{row}#{column}"
    end
  end

  def check_columns_computer(computer_mark, human_mark, iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      grid.each_key do |row|
        array << grid[row][column]
      end

      computer_marks = array.join.count(computer_mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row = rows[array.index("-")]
        return "#{row}#{column + 1}"
      end

      next if array.any?  { |mark| mark == computer_mark }
      next if array.none? { |mark| mark == human_mark }
      break if iteration.zero? && human_marks != 2

      row = rows[array.index("-")]
      return "#{row}#{column + 1}"
    end
  end

  def check_diagonals_computer(computer_mark, human_mark, iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      grid.each_key do |row|
        array << grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(computer_mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if array.any?  { |mark| mark == computer_mark }
      break if array.none? { |mark| mark == human_mark }
      break if iteration.zero? && human_marks != 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end

    3.times do |column|
      array = []
      grid.map { |key, _value| key }.reverse.each do |row|
        array << grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(computer_mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if array.any?  { |mark| mark == computer_mark }
      break if array.none? { |mark| mark == human_mark }
      break if iteration.zero? && human_marks != 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end
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

    finish_game if there_is_no_winner
  end

  def check_rows(last_player)
    grid.each_value do |row|
      the_winner_is(last_player) if row.all? { |mark| mark == last_player.mark }
    end
  end

  def check_columns(last_player)
    3.times do |column|
      array = []
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
      end

      return the_winner_is(last_player) if array.length == 3
    end
  end

  def check_diagonals(last_player)
    3.times do |column|
      array = []
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
        column += 1
      end

      return the_winner_is(last_player) if array.length == 3
    end

    3.times do |column|
      array = []
      grid.map { |key, _value| key }.reverse.each do |row|
        array << true if grid[row][column] == last_player.mark
        column += 1
      end

      return the_winner_is(last_player) if array.length == 3
    end
  end

  def there_is_no_winner
    array = []
    grid.each_value { |value| array << value }

    array.flatten.none? { |slot| slot == "-" }
  end

  def finish_game
    puts "There's no winner. Try again? (Y/N)"
    try_again
  end

  def the_winner_is(last_player)
    if last_player.name == "Computer"
      puts "Computer wins! Try again? (Y/N)"
    else
      puts "YOU WIN! Try again? (Y/N)"
    end

    try_again
  end

  def try_again
    input = STDIN.gets.chomp.downcase

    case input
    when "y"
      Game.new.start
    when "n"
      system "clear" or system "cls"
      puts "Thanks for playing. Hope you liked it!\n\n"
      exit
    end
  end

  def introduce_position(human)
    puts "Introduce a position:"
    input = STDIN.gets.chomp
    human.throw(input, self)
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
      board.introduce_position(human)
      computer.throw(board, human.mark)
    end
  end
end

Game.new.start
