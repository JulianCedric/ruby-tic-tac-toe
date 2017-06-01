require_relative "dummy_ai"

class Computer < Player
  attr_reader :board, :human_mark, :dummy_ai

  def initialize(name, mark, human_mark, board)
    super(name, mark)
    @human_mark = human_mark
    @board      = board
    @dummy_ai   = DummyAI.new(self, board, human_mark)
  end

  def throw
    board.print_board
    puts "Computer turn..."
    sleep rand(1..2) * 0.5
    location = dummy_ai.choose_location
    board.place_mark(mark, location)
  end
end
