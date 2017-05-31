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
