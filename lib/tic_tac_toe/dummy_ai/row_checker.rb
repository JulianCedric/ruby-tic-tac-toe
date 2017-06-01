class RowChecker < DummyAI
  attr_reader :board, :human_mark, :computer_mark

  def initialize(computer, board, human_mark)
    @board         = board
    @human_mark    = human_mark
    @computer_mark = computer.mark
  end

  def check_rows(iteration)
    board.grid.each do |row, columns|
      array = []
      columns.each { |column| array << column }

      computer_marks = array.join.count(computer_mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      next if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      column = array.index("-") + 1
      return "#{row}#{column}"
    end
  end
end
