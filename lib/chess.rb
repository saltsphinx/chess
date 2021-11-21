require_relative './board'
require_relative './ruleset'

class Chess
  include Ruleset
  attr_reader :game

  def initialize
    @game = Board.new
    @players = ['white', 'black']
  end

  def play
    main_menu
    play_game
    end_game
  end

  def play_game
    @game.setup
    until @game.game_over?
      @game.display
      puts @players.first.capitalize + '\'s turn'
      player_turn
      rotate
    end
  end

  def player_turn
    position, piece = get_position
    ruleset = self.send(piece.to_sym, position)
    ruleset.empty? ? no_moves(piece) : puts("Possible moves: " + ruleset.join(', '))
    destination = destination_loop(piece, ruleset)
    @game.move_piece(position, destination)
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
    when input.match(/^list/)
    else puts 'Bad input! Enter the file(a-h) followed by the rank(1-8), ie. c6'
    end
    user_input
  end

  def load

  end

  def end_game
    puts "Game over!\n#{@players.first.capitalize} wins!"
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