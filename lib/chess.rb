# frozen_string_literal: true

require_relative '../lib/game'

def new_game_or_load_save
  print "Press only 'enter' for New Game, l to load a Save File: "
  input = gets.chomp.downcase
  if input == ''
    puts 'New Game Of chess !'
    new_game = Game.new
    new_game.chess_board.show
    new_game.play
  elsif input == 'l'
    loaded_obj = Game.load_from_file
    puts loaded_obj
    loaded_obj.play
  else
    puts 'error try again...'
    new_game_or_load_save
  end
  rerun
end

def rerun
  puts "Would you like to rerun Press 'y' for yes or 'any other key' for no."
  repeat_input = gets.chomp.downcase
  if repeat_input == 'y'
    new_game_or_load_save
  else
    puts 'Thanks for playing!'
  end
end

new_game_or_load_save
