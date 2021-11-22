module Ruleset
  FILE = [*'a'..'h']
  RANK = [*'1'..'8']

  def rook(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves = moves + down(file, rank) + up(file, rank) + right(file, rank) + left(file, rank)
  end

  def bishop(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves += up_left(file, rank) + up_right(file, rank) + down_left(file, rank) + down_right(file, rank)
  end

  def queen(position)
    moves = []

    moves += rook(position) + bishop(position)
  end

  def pawn(position)
    file = position[0]
    rank = position[1]
    moves = []

    moves += pawn_move(file, rank) + pawn_attack(file, rank)
  end

  def king(position)
    file = position[0]
    rank = position[1]
    moves = []
    
    moves += king_horizontal(file, rank) + king_vertical(file, rank) + king_vertical_down(file, rank) + king_vertical_up(file, rank)
  end

  def knight(position)
    file = position[0]
    rank = position[1]
    moves = []
    knight_indices = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    rank_indices = knight_indices.map(&:first)
    files_indices = knight_indices.map(&:last)

    destinations = []
    rank_indices.zip(files_indices) do |rank_index, file_index|
      rank_difference =  RANK.index(rank) + rank_index
      file_difference =  FILE.index(file) + file_index
      next unless rank_difference.between?(0, 7) && file_difference.between?(0, 7)
      destinations << [FILE[file_difference], RANK[rank_difference]].join
    end

    destinations.map(&:to_sym).each do |destination|
      result = @game.enemy?(destination, @players.first)
      next if result == false
      moves << destination
    end
    moves
  end

  def check(position)
    return queen(position), knight(position)
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

  def pawn_move(file, rank)
    moves = []
    ranks = @players.first == 'white' ? RANK[RANK.index(rank) + 1..RANK.index(rank) + 2] : pawn_black(file, rank)

    for rank in ranks
      destination = (file + rank).to_sym
      result = @game.empty?(destination)
      break if result == false
      moves << (file + rank).to_sym
    end
    moves
  end

  def pawn_black(file, rank)
    ranks = []
    pawn_index = RANK.index(rank)
    ranks << RANK[pawn_index - 2] if pawn_index - 2 >= 0
    ranks << RANK[pawn_index - 1] if pawn_index - 1 >= 0
    ranks.reverse
  end

  def pawn_attack(file, rank)
    moves = []
    rank = @players.first == 'white' ? RANK[RANK.index(rank) + 1] : RANK[RANK.index(rank) - 1]
    files = []
    files << FILE[FILE.index(file) + 1] unless FILE.index(file) + 1 > 7
    files << FILE[FILE.index(file) - 1] unless FILE.index(file) - 1 < 0

    files.each do |file|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      break if result == false
      moves << destination if result == true
    end

    moves
  end

  def king_horizontal(file, rank)
    moves = []
    ranks = []
    rank_index = RANK.index(rank)
    ranks << RANK[rank_index + 1] if (rank_index + 1) <= 7
    ranks << RANK[rank_index - 1] if (rank_index -1) >= 0 

    for rank in ranks
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      moves << (file + rank).to_sym unless result == false
    end
    moves
  end

  def king_vertical(file, rank)
    moves = []
    files = []
    file_index = FILE.index(file)
    files << FILE[file_index + 1] if (file_index + 1) <= 7
    files << FILE[file_index - 1] if (file_index -1) >= 0 

    for file in files
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      moves << (file + rank).to_sym unless result == false
    end
    moves
  end

  def king_vertical_down(file, rank)
    moves = []
    rank = RANK[RANK.index(rank) - 1] if (RANK.index(rank) - 1) >= 0
    files = []
    files << FILE[FILE.index(file) + 1] if (FILE.index(file) + 1) <= 7
    files << FILE[FILE.index(file) - 1] if (FILE.index(file) - 1) >= 0 

    files.each do |file|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      moves << destination unless result == false
    end
    moves
  end

  def king_vertical_up(file, rank)
    moves = []
    rank = RANK[RANK.index(rank) + 1] if (RANK.index(rank) + 1) <= 7
    files = []
    files << FILE[FILE.index(file) + 1] if (FILE.index(file) + 1) <= 7
    files << FILE[FILE.index(file) - 1] if (FILE.index(file) - 1) >= 0 

    files.each do |file|
      break if rank.nil?
      destination = (file + rank).to_sym
      result = @game.enemy?(destination, @players.first)
      moves << destination unless result == false
    end
    moves
  end
end
