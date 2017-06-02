class Printer
  attr_reader :grid

  def initialize(board)
    @board = board
    @grid  = board.grid
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    print_game_title
    puts "\n"
    print_game_grid
    puts "\n"
  end

  private

  def print_game_title
    puts "   #############"
    puts "   #           #"
    puts "   #    TIC    #"
    puts "   #    TAC    #"
    puts "   #    TOE    #"
    puts "   #           #"
    puts "   #############"
  end

  def print_game_grid
    puts "     1 | 2 | 3 "
    puts "   -------------"
    puts " a | #{grid[:a][0]}   #{grid[:a][1]}   #{grid[:a][2]} |"
    puts "   ------------"
    puts " b | #{grid[:b][0]}   #{grid[:b][1]}   #{grid[:b][2]} |"
    puts "   ------------"
    puts " c | #{grid[:c][0]}   #{grid[:c][1]}   #{grid[:c][2]} |"
  end
end
