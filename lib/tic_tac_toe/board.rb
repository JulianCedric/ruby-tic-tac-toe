class Board
  attr_accessor :grid
  attr_reader   :game, :printer

  def initialize(game)
    create_grid
    @game    = game
    @printer = Printer.new(self)
  end

  def place_mark(mark, coordinates, human = false)
    return slot_not_available(coordinates, human) unless
      slot_available?(coordinates)

    grid[letter(coordinates)][number(coordinates)] = mark
  end

  def slot_available?(coordinates)
    grid[letter(coordinates)][number(coordinates)] == "-"
  end

  def reset_grid
    create_grid
  end

  private

  def create_grid
    @grid = { a: %w[- - -],
              b: %w[- - -],
              c: %w[- - -] }
  end

  def slot_not_available(coordinates, human)
    printer.print_board
    puts "The position '#{coordinates}' is already taken.\n\n"
    game.retry_turn(human)
  end

  def letter(coordinates)
    coordinates[0].to_sym
  end

  def number(coordinates)
    coordinates[1].to_i - 1
  end
end
