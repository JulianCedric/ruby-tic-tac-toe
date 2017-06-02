class Computer < Player
  attr_reader :board, :human, :ai

  def initialize(name, mark, human, board)
    super(name, mark)
    @board = board
    @human = human
    @ai    = AI.new(self, board, human)
  end

  def throw
    board.print_board
    puts "Computer turn..."
    sleep rand(1..2) * 0.5
    location = ai.choose_location
    board.place_mark(mark, location)
  end
end
