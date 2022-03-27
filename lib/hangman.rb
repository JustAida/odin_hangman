module Hangman
  class Game
    def initialize
      @template = template
      @remaining_guesses = @template.size
      @current_hangman = ""
      @secret_word = secret_word
      @incorrect_letters = []
      @correct_letters = []
    end

    # Randomly select a word between 5 and 12 characters long.
    def secret_word
      dictionary_file_name = "google_10000_english_no_swears.txt"
      dictionary = File.open(dictionary_file_name, "r", &:readlines)

      secret_words = dictionary.select do |word|
        word.chomp.length.between?(5, 12)
      end
      secret_words.sample
    end

    # Change the template to increase or decrease the remaining guesses.
    def template
      [
        " ____",
        " |   |",
        " |   o",
        " |  /|\\",
        " |  / \\",
        "_|_"
      ]
    end

    def display_hangman
      puts @current_hangman = @remaining_guesses == @template.size ? "" : @template[@remaining_guesses..-1]
    end

    # Display the guesses:
    #   _ for each letter that hasn't been guessed yet.
    #   Correct letters that have been chosen in the correct position.
    #   Incorrect letters that have already been chosen.
    #   For example: H _ N G _ _ N
    #                Incorrect letters: O J Z
    def display_guess_info
      guess_info = @secret_word.chars.map do |char|
        @correct_letters.include?(char) ? char : "_"
      end
      puts "\n#{guess_info.join(" ")}"
      puts "\nIncorrect letters: #{@incorrect_letters.join(" ")}"
    end

    def play
      until @remaining_guesses == -1
        puts "\nRemaining guesses: #{@remaining_guesses}"
        display_hangman
        display_guess_info
        @remaining_guesses -= 1
      end
    end
  end
end

# Ask the player for the guess each turn and it should be case-insensitive.
# Update the display according to the guess.
# Player will lose if out of guesses.

# Implement the functionality where the player can choose to save the progress of the game.

# Ask the player when the program first loads if the player want to load one of the saves.

Hangman::Game.new.play
