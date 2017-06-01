class Computer < Player
  attr_reader :board, :human_mark

  def initialize(name, mark, human_mark, board)
    super(name, mark)
    @human_mark = human_mark
    @board      = board
  end

  def throw
    board.print_board
    puts "Computer turn..."
    sleep (rand(1..2)) * 0.5
    board.place_mark(mark, choose_location)
  end

  private

  def choose_location
    2.times do |iteration|
      match_in_rows = check_rows(iteration)
      return match_in_rows if match_in_rows

      match_in_columns = check_columns(iteration)
      return match_in_columns if match_in_columns

      match_in_diagonals = check_diagonals(iteration)
      return match_in_diagonals if match_in_diagonals
    end

    choose_random_location
  end

  def check_rows(iteration)
    board.grid.each do |row, columns|
      array = []
      columns.each { |column| array << column }

      computer_marks = array.join.count(mark)
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

  def check_columns(iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << board.grid[row][column]
      end

      computer_marks = array.join.count(mark)
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

  def check_diagonals(iteration)
    rows = ["a", "b", "c"]

    3.times do |column|
      array = []
      board.grid.each_key do |row|
        array << board.grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end

    3.times do |column|
      array = []
      board.grid.map { |key, _value| key }.reverse.each do |row|
        array << board.grid[row][column]
        column += 1
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      break if empty_slots.zero?

      if computer_marks == 2 && human_marks.zero?
        row    = rows.reverse[array.index("-")]
        column = array.index("-") + 1
        return "#{row}#{column}"
      end

      break if computer_mark_or_no_human_mark(array)
      break if iteration.zero? && human_marks < 2

      row    = rows[array.index("-")]
      column = array.index("-") + 1
      return "#{row}#{column}"
    end
  end

  def computer_mark_or_no_human_mark(array)
    computer_mark = array.any?  { |mark| mark == self.mark }
    no_human_mark = array.none? { |mark| mark == human_mark }
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
