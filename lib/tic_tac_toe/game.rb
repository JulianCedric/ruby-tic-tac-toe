class Game
  attr_reader   :board,   :printer, :computer, :judge
  attr_accessor :players, :human1,  :human2

  def initialize
    @board    = Board.new(self)
    @printer  = board.printer
    @judge    = Judge.new(self)
    @players  = 1
    @human1   = Player.new("Human 1", "X")
    @human2   = Player.new("Human 2", "O")
    @computer = Computer.new("Computer", "O", human1, board)
  end

  def setup
    choose_players
    ask_players_names if players == 2
    start_game
  rescue Interrupt
    exit_game
  end

  def start_game
    loop do
      printer.print_board
      first_turn
      printer.print_board
      second_turn
    end
  rescue Interrupt
    exit_game
  end

  def retry_turn(player)
    position = ask_for_position(player)
    player.throw(position, board)
    judge.check_for_winner(player)
  end

  def try_again
    loop do
      case STDIN.gets.chomp.downcase
      when "y" then restart_game
      when "n" then exit_game
      else type_yes_or_no
      end
    end
  end

  private

  def choose_players
    printer.print_board
    puts "Choose players, 1 or 2?"
    input = STDIN.gets.chomp
    self.players = input.to_i
  end

  def ask_players_names
    printer.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    printer.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end

  def first_turn
    position = ask_for_position(human1)
    human1.throw(position, board)
    judge.check_for_winner(human1)
  end

  def second_turn
    if players == 1
      computer.throw
      judge.check_for_winner(computer)
    else
      position = ask_for_position(human2)
      human2.throw(position, board)
      judge.check_for_winner(human2)
    end
  end

  def ask_for_position(player = computer)
    if players == 1
      puts "Introduce a position:"
    else
      puts "#{player.name}, introduce a position:"
    end
    check_inputted_position
  end

  def check_inputted_position
    loop do
      input = STDIN.gets.chomp

      return input if input =~ /^[a-c][1-3]$/
      exit_game    if input == "exit".downcase

      printer.print_board
      puts "'#{input}' is not a correct position.\n\nIntroduce a position:"
    end
  end

  def restart_game
    board.reset_grid
    Game.new.setup
  end

  def type_yes_or_no
    printer.print_board
    puts "Please type 'Y' or 'N'."
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end
