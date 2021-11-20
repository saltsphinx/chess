class Board
  attr_reader :board

  UNI_PREFIX_WHITE = {ki: "\u265a", qu: "\u265b", ro: "\u265c", bi: "\u265d", kn: "\u265e", pa: "\u2659"}
  UNI_PREFIX_BLACK = {ki: "\u2654", qu: "\u2655", ro: "\u2656", bi: "\u2657", kn: "\u2658", pa: "\u265f"}

  def initialize(board = {})
    @board = board
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
    move_piece(piece_pos, destination_pos) if destination == nil || piece[-1] != destination[-1]
  end

  def move_piece(piece_pos, destination_pos)
    @board[destination_pos] = @board[piece_pos]
    @board[piece_pos] = nil
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

  def display_board
    (1..8).reverse_each do |rank|
      puts "  a b c d e f g h\n" if rank == 8
      print "#{rank}"
      ('a'..'h').each do |file|
        square = @board[(file + rank.to_s).to_sym]
        next print('  ') if square == nil
        square[-1] == 'w' ? print((' ' + UNI_PREFIX_WHITE[square[0..1].to_sym])) : print((' ' + UNI_PREFIX_BLACK[square[0..1].to_sym]))
      end
      print " #{rank}\n"
      puts "  a b c d e f g h" if rank == 1
    end
  end
end