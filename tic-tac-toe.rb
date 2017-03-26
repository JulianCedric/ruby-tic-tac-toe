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
  attr_reader :board, :human_mark

  def initialize(name, mark, human_mark, board)
    super(name, mark)
    @human_mark = human_mark
    @board      = board
  end

  def throw
    board.place_mark(self, mark, choose_location)
    sleep 1
  end

  def choose_location
    2.times do |iteration|
      match_in_rows = check_rows(iteration)
      return match_in_rows if match_in_rows

      match_in_columns = check_columns(iteration)
      return match_in_columns if match_in_columns

      match_in_diagonals = check_diagonals(iteration)
      return match_in_diagonals if match_in_diagonals
    end

    choose_random_location
  end

  def check_rows(iteration)
    board.grid.each do |row, columns|
      array = []
      columns.each { |column| array << column }

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      next if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      column = array.index("-") + 1
      return "#{row}#{column}"
    end
  end

  def check_columns(iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << board.grid[row][column]
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row = rows[array.index("-")]
        return "#{row}#{column + 1}"
      end

      next if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      row = rows[array.index("-")]
      return "#{row}#{column + 1}"
    end
  end

  def check_diagonals(iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << board.grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end

    3.times do |column|
      array = []
      board.grid.map { |key, _value| key }.reverse.each do |row|
        array << board.grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end
  end

  def computer_mark_or_no_human_mark(array)
    computer_mark = array.any?  { |mark| mark == self.mark }
    no_human_mark = array.none? { |mark| mark == human_mark }
    computer_mark || no_human_mark
  end

  def choose_random_location
    rows     = ["a", "b", "c"]
    columns  = [0, 1, 2]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row.to_sym][column]
      return "#{row}#{column + 1}" if location == "-"
    end
  end
end

class Board
  attr_reader :grid, :game

  def initialize(game)
    @grid = { a: ['-', '-', '-'],
              b: ['-', '-', '-'],
              c: ['-', '-', '-'] }
    @game = game
  end

  def place_mark(player, mark, coordinates)
    unless slot_available(coordinates)
      slot_not_available(coordinates)
      human.throw(game.introduce_position, self)
    end

    grid[letter(coordinates)][number(coordinates)] = mark

    print_board
    check_for_winner(player)
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

    game.finish if there_is_no_winner
  end

  def check_rows(last_player)
    grid.each_value do |row|
      game.the_winner_is(last_player) if row.all? { |mark| mark == last_player.mark }
    end
  end

  def check_columns(last_player)
    3.times do |column|
      array = []
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
      end

      return game.the_winner_is(last_player) if array.length == 3
    end
  end

  def check_diagonals(last_player)
    3.times do |column|
      array = []
      grid.each_key do |row|
        array << true if grid[row][column] == last_player.mark
        column += 1
      end

      return game.the_winner_is(last_player) if array.length == 3
    end

    3.times do |column|
      array = []
      grid.map { |key, _value| key }.reverse.each do |row|
        array << true if grid[row][column] == last_player.mark
        column += 1
      end

      return game.the_winner_is(last_player) if array.length == 3
    end
  end

  def there_is_no_winner
    array = []
    grid.each_value { |value| array << value }

    array.flatten.none? { |slot| slot == "-" }
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
  attr_reader :board, :human, :computer

  def initialize
    @board    = Board.new(self)
    @human    = Player.new("Human", "X")
    @computer = Computer.new("Computer", "O", human.mark, board)
  end

  def start
    loop do
      board.print_board
      human.throw(introduce_position, board)
      computer.throw
    end
  end

  def introduce_position
    puts "Introduce a position:"
    STDIN.gets.chomp
  end

  def finish
    puts "There's no winner. Try again? (Y/N)"
    try_again
  end

  def the_winner_is(last_player)
    case last_player.name
    when "Computer" then puts "Computer wins! Try again? (Y/N)"
    else puts "YOU WIN! Try again? (Y/N)"
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
end

Game.new.start
