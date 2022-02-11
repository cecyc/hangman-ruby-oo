require "paint"
require "spicy-proton"
require_relative "user_choice"

class Hangman
  DIFFICULTY_MSG = <<~DIFFICULTY
    Choose a level of difficulty
      1. Easy
      2. Hard
  DIFFICULTY

  TITLE = "Hangman 🤠"
  EASY_MAX_GUESSES = 10
  HARD_MAX_GUESSES = 8
  HARD_DIFFICULTY = 2
  DIFFICULTY_LEVELS = [1,2]

  def initialize
    @word = random_word
    @board = Array.new(@word.length, "_")
    @guesses = 0
    @max_guesses = EASY_MAX_GUESSES
    @used_letters = []
    @remaining_letters = ("a".."z").to_a
  end

  def start
    welcome
    choose_difficulty
    while valid_game?
      print_status
      run_game
    end
    exit_game
  end

  private

  def random_word
    [
      Spicy::Proton.adjective(max: 5),
      Spicy::Proton.noun(max: 5),
      Spicy::Proton.verb(max: 5),
    ].sample
  end

  def welcome
    puts Paint[TITLE.upcase, :blue]

    if ENV["DEBUG"]
      puts "The word is #{Paint[@word, :red]}"
    end
  end

  def valid_game?
    @guesses < @max_guesses
  end

  def print_status
    puts @board.join(" ")
    puts "Remaining letters: #{Paint[@remaining_letters, :green]}"
    puts "Used letters: #{Paint[@used_letters, :red]}"
  end

  def choose_difficulty
    validate_difficulty = ->(level) { DIFFICULTY_LEVELS.include?(level.to_i) }
    choice = UserChoice.new(DIFFICULTY_MSG, &validate_difficulty)
    adjust_difficulty(choice.get)
  end

  def adjust_difficulty(level)
    if level.to_i == HARD_DIFFICULTY
      @max_guesses = HARD_MAX_GUESSES
    end
  end

  def get_user_guess
    validate_input = ->(input) { input.length == 1 && !@used_letters.include?(input) }
    choice = UserChoice.new("Guess a letter", &validate_input)
    choice.get
  end

  def check_user_guess(user_guess)
    @word.chars.each_with_index do |char, index|
      if user_guess == char
        @board[index] = char
      end
    end
    @used_letters << user_guess
    @remaining_letters.delete(user_guess)
  end

  def check_win_condition
    unless @board.include?("_")
      puts "The word was #{Paint[@word, :green]}!"
      puts "You won! 🎉"
    end
  end

  def run_game
    check_user_guess(get_user_guess)
    check_win_condition
    @guesses += 1
  end
  
  def exit_game
    puts "You have run out of guesses! The word was #{Paint[@word, :red]}!"
    exit(0)
  end
end
