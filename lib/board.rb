# frozen_string_literal: true

# Chess board class, the playing ground, piece generator/mover, and board visualize
class Board
  attr_reader :board

  UNI_PREFIX_WHITE = { ki: "\u265a", qu: "\u265b", ro: "\u265c", bi: "\u265d", kn: "\u265e", pa: "\u265f" }
  UNI_PREFIX_BLACK = { ki: "\u2654", qu: "\u2655", ro: "\u2656", bi: "\u2657", kn: "\u2658", pa: "\u2659" }

  def initialize(board = {})
    @board = board
    @winner = nil
  end

  def setup
    generate_board_squares
    place_main
    place_pawn
  end

  def check_pos(position, player)
    square = @board[position]
    square && square[-1] == player[0] ? square : false
  end

  def enemy?(destination, player)
    square = @board[destination]
    return if square.nil?
    square[-1] == player[0] ? false : true
  end

  def empty?(destination)
    square = @board[destination]
    square.nil? ? true : false
  end

  def check_destin(destination, player)
    square = @board[destination]
    return false if square.to_s[-1] == player[0]
    square if square.nil? || square.to_s[-1] != player[0]
  end

  def move_piece(piece_pos, destination_pos)
    @board[destination_pos] = @board[piece_pos]
    @board[piece_pos] = nil
  end

  def game_over?; end

  def place_main
    main = %w[rook knight bishop queen king bishop knight rook]

    [1, 8].each do |rank|
      ('a'..'h').each_with_index do |file, index|
        symbol = (file << rank.to_s).to_sym
        @board[symbol] = rank == 1 ? (main[index] + 'w').to_sym : (main[index] + 'b').to_sym
      end
    end
  end

  def place_pawn
    pawns = ['pawn'] * 8

    [2, 7].each do |rank|
      ('a'..'h').each_with_index do |file, index|
        symbol = (file << rank.to_s).to_s.to_sym
        @board[symbol] = rank == 2 ? (pawns[index] + 'w').to_sym : (pawns[index] + 'b').to_sym
      end
    end
  end

  def generate_board_squares
    8.times.each do |rank|
      ('a'..'h').each do |file|
        symbol = (file << (rank + 1).to_s).to_s.to_sym
        @board[symbol] = nil
      end
    end
  end

  def display_board
    (1..8).reverse_each do |rank|
      puts "  a b c d e f g h\n" if rank == 8
      print rank.to_s
      ('a'..'h').each do |file|
        square = @board[(file + rank.to_s).to_sym]
        next print('  ') if square.nil?

        square[-1] == 'w' ? print((' ' + UNI_PREFIX_WHITE[square[0..1].to_sym])) : print((' ' + UNI_PREFIX_BLACK[square[0..1].to_sym]))
      end
      print " #{rank}\n"
      puts '  a b c d e f g h' if rank == 1
    end
  end
end
