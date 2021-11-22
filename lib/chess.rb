require_relative './board'
require_relative './ruleset'

class Chess
  include Ruleset
  attr_reader :game

  def initialize
    @game = Board.new
    @players = ['white', 'black']
    @winner = nil
  end

  def play
    main_menu
    play_game
    @game.display
    end_game
  end

  def play_game
    @game.setup
    while @winner.nil?
      @game.display
      puts @players.first.capitalize + '\'s turn'
      player_turn
      check_promotion
      rotate
      check_king
    end
  end

  def player_turn
    position, piece = get_position
    ruleset = self.send(piece.to_sym, position)
    return no_moves(piece) if ruleset.empty?
    puts("Possible moves: " + ruleset.join(', '))
    destination = destination_loop(piece, ruleset)
    @game.move_piece(position, destination)
  end

  def check_promotion
    pawn = @game.check_pawns
    promotion(pawn) if pawn
  end

  def check_king
    pieces = @players.first == 'white' ? %i[rookb bishopb queenb] : %i[rookw bishopw queenw]
    knight_piece = @players.first == 'white' ? :knightb : :knightw
    king_position = @game.find_piece(("king" + @players.first[0]).to_sym)
    return @winner = @players.last if king_position.nil?
    queen, knight = self.check(king_position)
    check_mate?(king_position) if queen.any? { |position| pieces.include?(@game.board[position]) } || knight.any? { |position| knight_piece == @game.board[position] }
  end

  def check_mate?(king_position)
    king_moves = self.king(king_position) << king_position
    pieces = @players.first == 'white' ? %i[rookb bishopb queenb knightb] : %i[rookw bishopw queenw knightw]
    enemy_pieces = @game.board.select { |_, piece| pieces.include?(piece) }
    enemy_moves = []

    rotate
    enemy_pieces.each do |position, piece|
      moves = self.send(piece.to_s[0..-2].to_sym, position)
      attacks = moves.select { |move| king_moves.include?(move) }
      enemy_moves += attacks unless attacks.empty?
    end
    rotate
    #puts "enemy moves #{enemy_moves}"
    #puts "moves left #{(king_moves - enemy_moves)}"
    if (king_moves - enemy_moves).empty?
      @winner = @players.first
      puts 'Checkmate!'
    end
  end

  def promotion(pawn)
    pieces = %w[rook knight bishop queen]
    puts "Promote your pawn, #{@players.first}\n#{pieces.join(', ')}"
    @game.set_piece(pawn, (promote_loop << @players.first[0]).to_sym)
  end

  def promote_loop
    pieces = %w[rook knight bishop queen]
    loop do
      input = gets.chomp.downcase
      return input if pieces.include?(input)
      puts "Bad input!\n#{pieces.join(', ')}"
    end
  end

  def no_moves(piece)
    puts "#{piece.capitalize} has no moves!"
    player_turn
  end

  def get_position
    position = position_loop
    square = @game.check_pos(position, @players.first)

    if square
      puts "#{square[0...-1].capitalize} -> ?"
      return position, square[0...-1]
    else
      puts 'Choose only pieces that belong to you!'
      get_position
    end
  end

  def get_destination(piece)
    destination = position_loop
    square = @game.check_destin(destination, @players.first)

    unless square == false
      square.nil? ? puts("#{piece.capitalize} -> #{destination}") : puts("#{piece.capitalize} -> #{square[0...-1].capitalize}")
      destination
    else
      puts 'Choose a square or enemy piece!'
      get_destination(piece)
    end
  end

  def position_loop
    loop do
      input = user_input
      return input.to_sym if input.match(/^[a-h][1-8]$/)
    end
  end

  def destination_loop(piece, ruleset)
    loop do
      destination = get_destination(piece)
      return destination if ruleset.include?(destination.to_sym)
      puts 'Illegal move!'
    end
  end

  def rotate
    @players[0], @players[1] = @players[1], @players[0]
  end

  def user_input
    input = gets.chomp
    case
    when input.match(/^[a-h][1-8]$/)
      return input
    when input.match(/^save/)
    when input.match(/^load/)
    else puts 'Bad input! Enter the file(a-h) followed by the rank(1-8), ie. c6'
    end
    user_input
  end

  def load

  end

  def end_game
    puts "Game over!\n#{@winner.capitalize} wins!"
  end

  private

  def main_menu
    puts "Chess\n\nOptions\n1 - Play\n2 - Load save"
    load if main_menu_input == 2
  end

  def main_menu_input
    user_input = nil

    until user_input
      user_input = gets.chomp.to_i
      user_input = nil unless user_input.between?(1, 2)
    end
    user_input
  end
end