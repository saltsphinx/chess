require_relative './board'

class Chess
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
      @game.display_board
      puts @players.first + '\' turn, \'help\''
      player_turn
      rotate
    end
  end

  def player_turn

  end

  def rotate
    @players[0], @players[1] = @players[1], @players[0]
  end

  def user_input
    input = gets.chomp
    case
    when input.match(/^[a-h][1-8]$/)
      input
    when input.match(/^save/)
      puts 'save'
    when input.match(/^load/)
      puts 'load'
    when input.match(/^list/)
      puts 'list'
    else
      puts 'Bad input! Try again.'
      user_input
    end
  end

  def load

  end

  def end_game
    puts "Game over!\n#{@players.first.capitalize} wins!"
  end

  private

  def main_menu
    puts "Chess\n\nOptions\n1 - Player\n2 - Load save"
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