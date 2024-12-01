require_relative './game/display'
require_relative './game/game_logic'

class Game
  include Display

  # Check if the player already finished a game and is replaying or not to avoid printing the tutorial each time
  def play(status = 'first time')
    puts Display.tutorial if status == 'first time'
    logic = GameLogic.new
    logic.set_role
    logic.set_secret_code
    logic.guess_code
    finish_game
  end

  def finish_game
    puts "Do want to play again? (press 'y' to play again or any other key to quit)"
    input = gets.chomp
    if input.downcase == 'y'
      if Gem.win_platform?
        system('cls')
      else
        system('clear')
      end

      play('again')
    else
      exit
    end
  end
end

Game.new.play
