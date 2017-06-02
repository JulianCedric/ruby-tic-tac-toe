class ColumnChecker < AI
  def initialize(computer, board, human, matches)
    @board    = board
    @human    = human
    @computer = computer
    @matches  = matches
  end

  def check_columns
    3.times do |column|
      array = board.grid.each_key.map { |row| board.grid[row][column] }
      get_matches(array, column)
    end
  end

  private

  def get_matches(line, column)
    players = [human, computer]
    players.each { |player| get_player_match(line, column, player) }
  end

  def get_player_match(line, column, player)
    player_data = parse_marks(player, line)
    return false unless player_data

    count       = player_data[0]
    empty_index = player_data[1]
    key         = %w[a b c][empty_index]
    column      = "#{key}#{column + 1}"

    matches[player.name][count] = column
  end
end
