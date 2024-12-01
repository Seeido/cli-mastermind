require_relative './string_formatting'

class GameLogic
  using StringFormatting

  attr_accessor :secret_code, :code_breaker

  PEGS =
    {
      '1' => "\e[48;5;1m  1  \e[0m", # red
      '2' => "\e[48;5;2m  2  \e[0m", # green
      '3' => "\e[48;5;3m  3  \e[0m", # yellow
      '4' => "\e[48;5;4m  4  \e[0m", # blue
      '5' => "\e[48;5;5m  5  \e[0m", # magenta
      '6' => "\e[48;5;6m  6  \e[0m" # cyan
    }.freeze

  def self.get_pegs(string_of_numbers)
    string_of_numbers.split('').map { |key| PEGS[key] }.join(' ')
  end

  def set_role
    puts Display.choose_role_text

    while true
      input = gets.chomp
      break if input.match?(/^[1-2]$/)

      puts 'Invalid input. Please type either "1" or "2" to choose your role.'.colorize(:red)
    end
    self.code_breaker = (input == '1' ? 'human' : 'computer')
  end

  def set_secret_code
    if code_breaker == 'computer'
      human_set_code
    elsif code_breaker == 'human'
      computer_set_code
    end
  end

  def human_set_code
    puts ''
    puts 'Please enter a 4-digit secret code for the computer to break.'
    while true
      input = gets.chomp
      break if input.match?(/^[1-6]{4}$/)

      puts 'Invalid input. Please enter exactly 4 digits, with each digit between 1 and 6.'.colorize(:red)
    end
    self.secret_code = input
    puts input.split('').map { |key| PEGS[key] }.join(' ') << ' is the secret code you set.'
  end

  def computer_set_code
    self.secret_code = 4.times.map { rand(1..6) }.join
  end

  def guess_code
    if code_breaker == 'human'
      human_guess_code
    elsif code_breaker == 'computer'
      computer_guess_code
    end
  end

  def human_guess_code
    (1..12).each do |i|
      puts ''
      puts "Turn ##{i}: Type in four numbers (1-6) to guess code, or 'q' to quit game."
      while true
        guess = gets.chomp
        if guess.match?(/^[1-6]{4}$/)
          puts current_guess_n_clues(guess)
          if get_clues(guess) == '⚫⚫⚫⚫'
            puts ''
            puts "Congratulaions! You've correctly guessed the code set by the computer.".colorize(:green)
            return
          end
          break
        elsif guess.match?(/^q$/i)
          return
        end
        puts 'Invalid input. Please enter exactly 4 digits, with each digit between 1 and 6.'.colorize(:red)
      end
    end
    puts ''
    puts "You weren't able to correctly guess the code set by the computer.".colorize(:red)
    nil
  end

  # The algorithm/strategy that the code follows is the one demonstrated by Donald Knuth in 1977
  def computer_guess_code
    possible_codes = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    (1..12).each do |i|
      guess = possible_codes.sample.join('')
      puts ''
      puts "Computer turn ##{i}"
      puts current_guess_n_clues(guess)
      clues = get_clues(guess)
      if clues == '⚫⚫⚫⚫'
        puts ''
        puts 'The computer has correctly guessed the secret code that you set.'.colorize(:red)
        return
      end
      possible_codes = possible_codes.select do |current_code|
        get_clues(guess, current_code.join('')) == clues
      end
      sleep(2)
    end
    puts ''
    puts "The computer couldn't correctly guess the secret code that you set!".colorize(:green)
    nil
  end

  def current_guess_n_clues(guess)
    guess.split('').map { |key| PEGS[key] }.join(' ') << '  Clues: ' << get_clues(guess)
  end

  # Give the option for the method caller to compare the guess against a specific code (other than the set secret code) because such feature is necessary for the algorithm used by the computer to guess the code ('computer_guess_code' method)
  def get_clues(guess, code = secret_code)
    pegs = ''
    code_arr = code.split('')
    guess_arr = guess.split('')

    guess_arr.each_with_index do |guess_peg, i|
      next unless guess_peg == code_arr[i]

      pegs << '⚫'
      # Remove the peg from both arrays to prevent overlapping and producing wrong clues/feedback when checking for white pegs
      code_arr[i] = nil
      guess_arr[i] = nil
    end
    guess_arr.each_with_index do |guess_peg, _i|
      next if guess_peg.nil?

      if code_arr.index(guess_peg)
        pegs << '⚪'
        code_arr[code_arr.index(guess_peg)] = nil
      end
    end

    pegs
  end
end
