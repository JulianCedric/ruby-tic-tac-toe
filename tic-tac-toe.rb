# Project: Tic-tac-toe in Ruby for The Odin Project
# Author: Luján Fernaud
#
# Instructions:
#
# Build a tic-tac-toe game on the command line where two human players can play
# against each other and the board is displayed in between turns.
#
# Wikipedia: https://en.wikipedia.org/wiki/Tic-tac-toe

class Player
  attr_accessor :name
  attr_reader   :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

  def throw(coordinates, board)
    board.place_mark(mark, coordinates, self)
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
    board.print_board
    puts "Computer turn..."
    sleep (rand(1..2)) * 0.5
    board.place_mark(mark, choose_location)
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
        row    = rows.reverse[array.index("-")]
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
  attr_accessor :grid
  attr_reader   :game

  def initialize(game)
    @grid = { a: ['-', '-', '-'],
              b: ['-', '-', '-'],
              c: ['-', '-', '-'] }
    @game = game
  end

  def reset_grid
    self.grid = { a: ['-', '-', '-'],
                  b: ['-', '-', '-'],
                  c: ['-', '-', '-'] }
  end

  def place_mark(mark, coordinates, human = false)
    unless slot_available(coordinates)
      slot_not_available(coordinates)
      human.throw(game.introduce_position(human), self)
    end

    return false unless slot_available(coordinates)

    grid[letter(coordinates)][number(coordinates)] = mark
    print_board
  end

  def slot_available(coordinates)
    grid[letter(coordinates)][number(coordinates)] == "-"
  end

  def slot_not_available(coordinates)
    print_board
    puts "The position '#{coordinates}' is already taken.\n\n"
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
    puts "   #############"
    puts "   #           #"
    puts "   #    TIC    #"
    puts "   #    TAC    #"
    puts "   #    TOE    #"
    puts "   #           #"
    puts "   #############"
    puts "\n"
    puts "     1 | 2 | 3 "
    puts "   -------------"
    puts " a | #{grid[:a][0]}   #{grid[:a][1]}   #{grid[:a][2]} |"
    puts "   ------------"
    puts " b | #{grid[:b][0]}   #{grid[:b][1]}   #{grid[:b][2]} |"
    puts "   ------------"
    puts " c | #{grid[:c][0]}   #{grid[:c][1]}   #{grid[:c][2]} |"
    puts "\n"
  end
end

class Game
  attr_reader   :board, :computer
  attr_accessor :players, :human1, :human2

  def initialize
    @board    = Board.new(self)
    @players  = 1
    @human1   = Player.new("Human 1", "X")
    @human2   = Player.new("Human 2", "O")
    @computer = Computer.new("Computer", "O", human1.mark, board)
  end

  def setup
    board.print_board
    puts "Choose players, 1 or 2?"
    input = STDIN.gets.chomp
    self.players = input.to_i

    start if players == 1

    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp

    start
  end

  def start
    loop do
      board.print_board
      human1.throw(introduce_position(human1), board)
      check_for_winner(human1)
      if players == 1
        computer.throw
        check_for_winner(computer)
      else
        human2.throw(introduce_position(human2), board)
        check_for_winner(human2)
      end
    end
  end

  def introduce_position(player = computer)
    if players == 1
      puts "Introduce a position:"
    else
      puts "#{player.name}, introduce a position:"
    end

    loop do
      begin
        input = STDIN.gets.chomp
        return input if input =~ /^[a-c][1-3]$/
        exit_game if input == "exit".downcase

        board.print_board
        puts "'#{input}' is not a correct position.\n\nIntroduce a position:"
      rescue Interrupt
        board.print_board
        exit_game
      end
    end
  end

  def check_for_winner(last_player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)

    finish_game if there_is_no_winner
  end

  def check_rows(last_player)
    board.grid.each_value do |row|
      the_winner_is(last_player) if row.all? { |mark| mark == last_player.mark }
    end
  end

  def check_columns(last_player)
    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << true if board.grid[row][column] == last_player.mark
      end

      return the_winner_is(last_player) if array.length == 3
    end
  end

  def check_diagonals(last_player)
    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << true if board.grid[row][column] == last_player.mark
        column += 1
      end

      return the_winner_is(last_player) if array.length == 3
    end

    3.times do |column|
      array = []
      board.grid.map { |key, _value| key }.reverse.each do |row|
        array << true if board.grid[row][column] == last_player.mark
        column += 1
      end

      return the_winner_is(last_player) if array.length == 3
    end
  end

  def there_is_no_winner
    array = []
    board.grid.each_value { |value| array << value }
    array.flatten.none? { |slot| slot == "-" }
  end

  def finish_game
    puts "There's no winner. Try again? (Y/N)"
    try_again
  end

  def the_winner_is(last_player)
    case last_player.name
    when "Computer" then puts "Computer wins! Try again? (Y/N)"
    when "Human 1"  then puts "YOU WIN! Try again? (Y/N)"
    else puts "#{last_player.name} wins! Try again? (Y/N)"
    end
    try_again
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y"
        board.reset_grid
        start
      when "n"
        exit_game
      else
        board.print_board
        puts "Please type 'Y' or 'N'."
      end
    end
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end

Game.new.setup
