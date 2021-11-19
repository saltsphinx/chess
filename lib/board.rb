class Board
  def initialize(board = {})
    @board = {}
  end

  def setup
    generate_board_squares
    place_pieces
  end

  def place_pieces
    place_main
    place_pawn
  end

  def check_piece(position)
    @board[position]
  end

  def player_move(piece_pos, destination_pos)
    piece = @board[piece_pos]
    destination = @board[destination_pos]

    return if piece_pos.nil?
    return move_piece if destination == nil
    take_piece unless piece_pos[-1] == destination[-1]
  end

  def take_piece
  end

  def move_piece
  end

  def place_main
    main = ['rook', 'knight', 'bishop', 'queen', 'king', 'bishop', 'knight', 'rook']

    [1, 8].each do |rank|
      ('a'..'h').each_with_index do |file, index|
        symbol = "#{file << rank.to_s}".to_sym
        rank == 1 ? @board[symbol] = (main[index] + 'w').to_sym : @board[symbol] = (main[index] + 'b').to_sym
      end
    end
  end

  def place_pawn
    pawns = ['pawn'] * 8

    [2, 7].each do |rank|
      ('a'..'h').each_with_index do |file, index|
        symbol = "#{file << rank.to_s}".to_sym
        rank == 2 ? @board[symbol] = (pawns[index] + 'w').to_sym : @board[symbol] = (pawns[index] + 'b').to_sym
      end
    end
  end

  def generate_board_squares
    8.times.each do |rank|
      ('a'..'h').each do |file|
        symbol = "#{file << (rank + 1).to_s}".to_sym
        @board[symbol] = nil
      end
    end
  end
end