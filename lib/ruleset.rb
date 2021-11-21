module Ruleset
  FILE = [*'a'..'h']
  RANK = [*'1'..'8']
  def rook(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves = moves + down(file, rank) + up(file, rank) + right(file, rank) + left(file, rank)
  end

  def up(file, rank)
    up_moves = []
    ranks = RANK[RANK.index(rank) + 1..7]
    
    for rank in ranks
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      up_moves << (file + rank).to_sym
      break if result == true
    end
    up_moves
  end

  def down(file, rank)
    down_moves = []
    ranks = RANK[0...RANK.index(rank)].reverse

    for rank in ranks
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      down_moves << (file + rank).to_sym
      break if result == true
    end
    down_moves
  end

  def right(file, rank)
    right_moves = []
    files = FILE[FILE.index(file) + 1..7]

    for file in files
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      right_moves << (file + rank).to_sym
      break if result == true
    end
    right_moves
  end

  def left(file, rank)
    left_moves = []
    files = FILE[0...FILE.index(file)].reverse

    for file in files
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      left_moves << (file + rank).to_sym
      break if result == true
    end
    left_moves
  end
end
