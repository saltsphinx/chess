module Ruleset
  FILE = [*'a'..'h']
  RANK = [*'1'..'8']

  def rook(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves = moves + down(file, rank) + up(file, rank) + right(file, rank) + left(file, rank)
  end

  def queen(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves = moves + down(file, rank) + up(file, rank) + right(file, rank) + left(file, rank) + up_left(file, rank) + up_right(file, rank) + down_left(file, rank) + down_right(file, rank)
  end

  def bishop(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves += up_left(file, rank) + up_right(file, rank) + down_left(file, rank) + down_right(file, rank)
  end

  def pawn(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves += pawn_up(file, rank) + pawn_attack(file, rank)
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

  def up_left(file, rank)
    moves = []
    files = FILE[0...FILE.index(file)].reverse
    ranks = RANK[RANK.index(rank) + 1..7]

    files.zip(ranks).each do |file, rank|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination
      break if result == true
    end
    moves
  end

  def up_right(file, rank)
    moves = []
    files = FILE[FILE.index(file) + 1..7]
    ranks = RANK[RANK.index(rank) + 1..7]

    files.zip(ranks).each do |file, rank|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination
      break if result == true
    end
    moves
  end

  def down_right(file, rank)
    moves = []
    files = FILE[FILE.index(file) + 1..7]
    ranks = RANK[0...RANK.index(rank)].reverse

    files.zip(ranks).each do |file, rank|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination
      break if result == true
    end
    moves
  end

  def down_left(file, rank)
    moves = []
    files = FILE[0...FILE.index(file)].reverse
    ranks = RANK[0...RANK.index(rank)].reverse

    files.zip(ranks).each do |file, rank|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination
      break if result == true
    end
    moves
  end

  def pawn_up(file, rank)
    moves = []
    ranks = RANK[RANK.index(rank) + 1..RANK.index(rank) + 2]

    for rank in ranks
      destination = (file + rank).to_sym
      result = @game.empty?(destination)
      break if result == false
      moves << (file + rank).to_sym
    end
    moves
  end

  def pawn_attack(file, rank)
    moves = []
    rank = RANK[RANK.index(rank) + 1]
    files = []
    files << FILE[FILE.index(file) + 1]
    files << FILE[FILE.index(file) - 1] unless FILE.index(file) - 1 < 0

    files.each do |file|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination
    end

    moves
  end
end
