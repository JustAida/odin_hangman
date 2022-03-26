# Load dictionary.
dictionary_file_name = "google_10000_english_no_swears.txt"
dictionary = File.open(dictionary_file_name, "r") do |file|
  file.readlines
end

# Randomly select a word between 5 and 12 characters long.
# Make a template for stick figure.
# Make a counter for the remaining incorrect guesses.
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
