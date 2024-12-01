require_relative './string_formatting'
require_relative './game_logic'

module Display
  using StringFormatting

  def self.tutorial
    <<~TUTORIAL
      #{'Welcome to Mastermind:'.underline}

      #{'Objective:'.underline}

      Mastermind is a game of code-making and code-breaking.

      You’ll get to choose your role:
      - As the code #{'breaker'.underline}: You try to guess the secret code set by the computer.
      - As the code #{'maker'.underline}: You set a secret code, and the computer will try to guess it.

      #{'The Rules:'.underline}

      1. The secret code consists of 4 pegs, each chosen from the set of number/color combinations below:
         #{GameLogic.get_pegs('123456')}

      2. Colors may repeat in the code.

      3. The code breaker has 12 attempts to guess the code.

      #{'How to Play:'.underline}

      1. Choose your role:
         - Code breaker: Try to guess the secret code that the computer set.
         - Code maker: Set a secret code for the computer to guess.

      2. Feedback is given for each guess:
         - A black peg (⚫) for each color that is correct in both color and position.
         - A white peg (⚪) for each color that is correct in color but not in position.
         - No peg for incorrect guesses.

      3. Use the feedback to refine your guesses or see how well the computer performs against your code.

      #{'Winning:'.underline}

      - As the code breaker: You win by guessing the code that the computer set before running out of attempts!

      - As the code maker: You win if the computer cannot guess your code within the allowed attempts.

      #{'Example:'.underline}

      Secret code:        #{GameLogic.get_pegs('1446')}

      Code breaker guess: #{GameLogic.get_pegs('4421')}

      Feedback/clues:     ⚫⚪⚪

      Ready to test your skills as a code breaker or code maker?

    TUTORIAL
  end

  def self.choose_role_text
    <<~SELECTION
      Please choose the role you want to play as (type 1 or 2 to choose).
      1. Code BREAKER
      2. Code MAKER
    SELECTION
  end
end
