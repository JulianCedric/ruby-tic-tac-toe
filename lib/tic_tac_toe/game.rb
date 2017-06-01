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
    choose_players
    ask_players_names if players == 2
    start
  end

  def start
    loop do
      board.print_board
      first_turn
      second_turn
    end
  end

  private

  def choose_players
    board.print_board
    puts "Choose players, 1 or 2?"
    input = STDIN.gets.chomp
    self.players = input.to_i
  end

  def ask_players_names
    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end

  def first_turn
    position = introduce_position(human1)
    human1.throw(position, board)
    check_for_winner(human1)
  end

  def second_turn
    if players == 1
      computer.throw
      check_for_winner(computer)
    else
      position = introduce_position(human2)
      human2.throw(position, board)
      check_for_winner(human2)
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
