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
  end

  def rotate
    @players[0], @players[1] = @players[1], @players[0]
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