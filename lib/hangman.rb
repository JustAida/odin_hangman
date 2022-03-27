require "json"

module Hangman
  class Game
    def initialize
      @template = template
      @remaining_guesses = @template.size
      @secret_word = secret_word
      @incorrect_letters = []
      @correct_letters = []
      @player = Player.new(self)
      @save_files = save_files
      intro
    end

    def intro
      puts "Welcome to Hangman game!"
      puts "How to play:"
      puts "  - Type a letter from A-Z for each turn."
      puts "  - If you wish to save the game you could type \"save\" at anytime."
      puts "That's it! Enjoy playing the game!"
      display_save_files unless @save_files.empty?
    end

    # Randomly select a word between 5 and 12 characters long.
    def secret_word
      dictionary_file_name = "google_10000_english_no_swears.txt"
      dictionary = File.open(dictionary_file_name, "r", &:readlines)

      secret_words = dictionary.select do |word|
        word.chomp.length.between?(5, 12)
      end
      secret_words.sample.chomp
    end

    # Change the template to increase or decrease the remaining guesses.
    def template
      [
        " ____",
        " |   |",
        " |   o",
        " |  /|\\",
        " |  / \\",
        " |", # Add/remove this to increase/decrease the reamining guesses.
        "==="
      ]
    end

    def display_hangman
      puts "\nRemaining guesses: #{@remaining_guesses}\n\n"
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
        @correct_letters.include?(char) ? char.upcase : "_"
      end
      puts "\n#{guess_info.join(" ")}"
      puts "\nIncorrect letters: #{@incorrect_letters.map(&:upcase).join(" ")}\n\n"
    end

    def valid_guess?(guess)
      guess.length == 1 && ("a".."z").include?(guess) &&
        !@incorrect_letters.include?(guess) && !@correct_letters.include?(guess)
    end

    def ask_player_guess
      print "Type the guess or \"save\": "
      @player_guess = @player.guess
      save if @player_guess == "save"
      ask_player_guess until valid_guess?(@player_guess)
    end

    def update_guess_info
      if @secret_word.chars.include?(@player_guess)
        @correct_letters.push(@player_guess)
        @correct = true
      else
        @incorrect_letters.push(@player_guess)
        @correct = false
      end
    end

    def win?
      @secret_word.chars.all? { |char| @correct_letters.include?(char) }
    end

    def win_message
      display_hangman
      display_guess_info
      puts "\nYou win!!"
      puts "Thanks for playing!"
      exit
    end

    def play
      until @remaining_guesses == 0
        display_hangman
        display_guess_info
        ask_player_guess
        update_guess_info
        @remaining_guesses -= 1 unless @correct
        return win_message if win?
      end
      display_hangman
      puts "\nYou ran out of guesses. It was #{@secret_word}."
    end

    def save
      folder_name = "save_files"
      Dir.mkdir(folder_name) unless Dir.exist?(folder_name)
      file_name = "#{folder_name}/#{Time.now.to_s.split[0..1].join("_")}.json"
      File.open(file_name, "w") do |file|
        JSON.dump({
                    remaining_guesses: @remaining_guesses,
                    secret_word: @secret_word,
                    incorrect_letters: @incorrect_letters,
                    correct_letters: @correct_letters
                  }, file)
      end
      puts "\nGame Saved!\n\n"
    end

    def load(save_file_number)
      File.open(@save_files[save_file_number], "r") do |file|
        data = JSON.parse(file.read)
        @remaining_guesses = data["remaining_guesses"]
        @secret_word = data["secret_word"]
        @incorrect_letters = data["incorrect_letters"]
        @correct_letters = data["correct_letters"]
      end
      play
    end

    def save_files
      folder_name = "save_files"
      Dir.glob("#{folder_name}/*")
    end

    def display_save_files
      puts "\nWould you like to load a save file? [Type \"y\" to load or anything else if you don't want to load]"
      load_file = gets.chomp.downcase
      return "" unless load_file == "y"

      puts "\nWhich save file would you like to load? [Type number only]"
      @save_files.each_with_index do |file, index|
        puts "#{index + 1}. #{file.sub("save_files/", "")}"
      end
      choice = gets.chomp until choice.to_i > 0
      load(choice.to_i - 1)
    end
  end

  class Player
    def initialize(game)
      @game = game
    end

    def guess
      gets.chomp.downcase
    end
  end
end

# Implement the functionality where the player can choose to save the progress of the game.

# Ask the player when the program first loads if the player want to load one of the saves.

Hangman::Game.new.play
