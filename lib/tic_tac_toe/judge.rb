class Judge
  attr_reader :game, :board, :printer

  def initialize(game)
    @game    = game
    @board   = game.board
    @printer = game.printer
  end

  def check_for_winner(last_player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)

    finish_game if there_is_no_winner
  end

  private

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
    printer.print_board
    puts "There's no winner. Try again? (Y/N)"
    game.try_again
  end

  def the_winner_is(last_player)
    printer.print_board
    case last_player.name
    when "Computer" then puts "Computer wins! Try again? (Y/N)"
    when "Human 1"  then puts "YOU WIN! Try again? (Y/N)"
    else puts "#{last_player.name} wins! Try again? (Y/N)"
    end
    game.try_again
  end
end
