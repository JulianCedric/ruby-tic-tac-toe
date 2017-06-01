class ColumnChecker < DummyAI
  attr_reader :board, :human_mark, :computer_mark

  def initialize(computer, board, human_mark)
    @board         = board
    @human_mark    = human_mark
    @computer_mark = computer.mark
  end

  def check_columns(iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << board.grid[row][column]
      end

      computer_marks = array.join.count(computer_mark)
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
end
