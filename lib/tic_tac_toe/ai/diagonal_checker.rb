class DiagonalChecker < AI
  def initialize(computer, board, human, matches)
    @board    = board
    @human    = human
    @computer = computer
    @matches  = matches
  end

  def check_diagonals
    diagonals.each { |diagonal| get_matches(diagonal) }
  end

  private

  def diagonals
    [build_diagonal_one, build_diagonal_two]
  end

  def build_diagonal_one
    array  = []
    column = 0
    board.grid.each_key do |row|
      array << board.grid[row][column]
      column += 1
    end
    array
  end

  def build_diagonal_two
    array  = []
    column = 0
    board.grid.map { |key, _value| key }.reverse.each do |row|
      array << board.grid[row][column]
      column += 1
    end
    array
  end

  def get_matches(line)
    players = [human, computer]
    players.each { |player| get_player_match(line, player) }
  end

  def get_player_match(line, player)
    player_data = parse_marks(player, line)
    return false unless player_data

    count       = player_data[0]
    empty_index = player_data[1]
    key         = %w[a b c][empty_index]
    column      = "#{key}#{empty_index + 1}"

    matches[player.name][count] = column
  end
end
