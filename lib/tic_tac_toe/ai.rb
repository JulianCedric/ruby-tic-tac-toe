class AI
  include Regexps

  attr_accessor :matches
  attr_reader   :computer,    :board,          :human
  attr_reader   :row_checker, :column_checker, :diagonal_checker

  def initialize(computer, board, human)
    @computer         = computer
    @board            = board
    @human            = human
    @matches          = { computer.name => {}, human.name => {} }
    @row_checker      = RowChecker.new(computer, board, human, matches)
    @column_checker   = ColumnChecker.new(computer, board, human, matches)
    @diagonal_checker = DiagonalChecker.new(computer, board, human, matches)
  end

  def choose_location
    find_good_locations
    return location if location
    choose_random_location
  end

  private

  def find_good_locations
    row_checker.check_rows
    column_checker.check_columns
    diagonal_checker.check_diagonals
  end

  def location
    good_match = proc { |match| match && board.slot_available?(match) }
    coordinates.select(&good_match).first
  end

  def coordinates
    [matches[computer.name][2], matches[human.name][2],
     matches[computer.name][1], matches[human.name][1]]
  end

  def parse_marks(player, line)
    regexps(player).each do |regexp|
      match = line.join.match(regexp)
      next unless match

      marks_count = match[0].count(player.mark)
      empty_index = match[0] =~ /\-/

      return [marks_count, empty_index] if marks_count
    end
    false
  end

  def choose_random_location
    rows    = %w[a b c]
    columns = [0, 1, 2]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row.to_sym][column]
      return "#{row}#{column + 1}" if location == "-"
    end
  end
end
