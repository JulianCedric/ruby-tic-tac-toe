class DummyAI
  attr_reader :board, :human_mark, :computer_mark
  attr_reader :row_checker, :column_checker, :diagonal_checker

  def initialize(computer, board, human_mark)
    @board            = board
    @human_mark       = human_mark
    @computer_mark    = computer.mark
    @row_checker      = RowChecker.new(computer, board, human_mark)
    @column_checker   = ColumnChecker.new(computer, board, human_mark)
    @diagonal_checker = DiagonalChecker.new(computer, board, human_mark)
  end

  def choose_location
    2.times do |iteration|
      match_in_rows = row_checker.check_rows(iteration)
      return match_in_rows if match_in_rows

      match_in_columns = column_checker.check_columns(iteration)
      return match_in_columns if match_in_columns

      match_in_diagonals = diagonal_checker.check_diagonals(iteration)
      return match_in_diagonals if match_in_diagonals
    end

    choose_random_location
  end

  private

  def computer_mark_or_no_human_mark(array)
    computer_mark = array.any?  { |m| m == computer_mark }
    no_human_mark = array.none? { |m| m == human_mark }
    computer_mark || no_human_mark
  end

  def choose_random_location
    rows     = ["a", "b", "c"]
    columns  = [0, 1, 2]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row.to_sym][column]
      return "#{row}#{column + 1}" if location == "-"
    end
  end
end
