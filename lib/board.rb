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
