# frozen_string_literal: true

require_relative '../lib/game'

def new_game_or_load_save
  loop do
    print "Press only 'enter' for New Game, l to load a Save File: "
    input = gets.chomp.downcase
    if input == ''
      puts 'New Game Of chess !'
      new_game = Game.new
      new_game.chess_board.show
      new_game.play
      break
    elsif input == 'l' && Dir.exist?('saves')
      loaded_obj = Game.load_from_file
      puts loaded_obj
      loaded_obj.play
      break
    else
      puts 'error try again...'
    end
  end
  rerun
end

def rerun
  puts "Would you like to rerun Press 'y'/'any other key' for yes/no."
  repeat_input = gets.chomp.downcase
  if repeat_input == 'y'
    new_game_or_load_save
  else
    puts 'Thanks for playing!'
  end
end

new_game_or_load_save
