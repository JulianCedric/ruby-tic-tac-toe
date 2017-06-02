class RowChecker < AI
  def initialize(computer, board, human, matches)
    @board    = board
    @human    = human
    @computer = computer
    @matches  = matches
  end

  def check_rows
    board.grid.each { |key, row| get_row_matches(key, row) }
  end

  private

  def get_row_matches(key, row)
    players = [human, computer]
    players.each { |player| get_player_match(key, row, player) }
  end

  def get_player_match(key, row, player)
    player_data = parse_marks(player, row)
    return false unless player_data

    count       = player_data[0]
    empty_index = player_data[1]
    column      = "#{key}#{empty_index + 1}"

    matches[player.name][count] = column
  end
end
