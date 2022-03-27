module Hangman
  class Game
    attr_accessor :hangman_template

    def initialize
      # Make a template for stick figure.
      @template = [
        " ____",
        " |   |",
        " |   o",
        " |  /|\\",
        " |  / \\",
        "_|_"
      ]
      # Make a counter for the remaining incorrect guesses.
      @remaining_guesses = 6
      @current_hangman = ""
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

    def display_hangman
      puts @current_hangman = @remaining_guesses == 6 ? "" : @template[@remaining_guesses..-1]
    end

    def play
      until @remaining_guesses == -1
        puts @remaining_guesses
        display_hangman
        @remaining_guesses -= 1
      end
    end
  end
end

# Display the guesses: 
#   _ for each letter that hasn't been guessed yet.
#   Correct letters that have been chosen in the correct position.
#   Incorrect letters that have already been chosen.
#   For example: H _ N G _ _ N [O, J, Z]

# Ask the player for the guess each turn and it should be case-insensitive.
# Update the display according to the guess.
# Player will lose if out of guesses.

# Implement the functionality where the player can choose to save the progress of the game.

# Ask the player when the program first loads if the player want to load one of the saves.

puts Hangman::Game.new.play
