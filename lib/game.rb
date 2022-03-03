# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
require_relative '../lib/move_manager'
require 'yaml'

# a dummy game class that plays a round of chess
class Game
  attr_reader :chess_board, :pl_w, :pl_b, :move_manager, :current_player

  def initialize
    @chess_board = ChessBoard.new
    @pl_b = Player.new('B')
    @pl_w = Player.new('W')
    @move_manager = MoveManager.new(chess_board)
    @current_player = pl_w
  end

  def to_s
    lm = move_manager.last_move
    %{
      #{chess_board.show}
      last_(non_castle)move: #{lm[0]} moved from #{(lm[4] + 97).chr}#{8 - lm[3]} to #{(lm[2] + 97).chr}#{8 - lm[1]}
      #{current_player.color} to move!
        }
  end

  def save_to_file(chess_obj)
    Dir.mkdir('saves') unless Dir.exist?('saves') # holds all yaml saves user makes
    print 'enter name of save file: '
    input = gets.chomp
    File.open("saves/#{input}.yaml", 'w') do |save_file|
      save_file.puts YAML::dump(chess_obj)
    end
  end

  def self.load_from_file # had to make this a class method cause u cant load instance by calling load on another instance
    Dir["saves/*"].each.with_index(1) { |file, idx| puts "#{idx} #{file}" }
    print 'To select the file to load enter only the filename: '
    input = gets.chomp
    if !File.exist?("saves/#{input}.yaml")
      puts 'No save found!!'
      puts '----------'
      load_from_file
    else
      puts 'Save load succesfull!'
      File.open("saves/#{input}.yaml", 'r') do |save_file|
        YAML::load(save_file)
      end
    end
  end

  def ask_move_input(player)
    print "#{player.color} enter move of form 'd2d4': "
    gets.chomp
  end

  def verify?(input)
    input.match?(/^[a-h][1-8][a-h][1-8]$/) || input == 'save'
  end

  def valid_move_input(player)
    loop do
      input = ask_move_input(player)
      return input if verify?(input)

      puts 'invalid form of input'
    end
  end

  def plyr_input_to_grid_input(player_input)
    fc, fr, tc, tr = player_input.chars
    fc = fc.ord - 97
    fr = 8 - fr.to_i
    tc = tc.ord - 97
    tr = 8 - tr.to_i
    [fr, fc, tr, tc]
  end

  def piece_exist?(from_row, from_column) # game should have this? # make_legal_move pt
    chess_board.occupied_square?(from_row, from_column)
  end

  def player_piece?(player, piece) # game should have this? # make_legal_move pt
    piece.color == player.color
  end

  def determine_move_type(fr, fc, tr, tc)
    unless piece_exist?(fr, fc)
      puts 'this square is empty'
      return false
    end

    piece = chess_board.square(fr, fc)

    unless player_piece?(current_player, piece)
      puts 'this is not ur piece'
      return false
    end
    # braching of noarmal/castle move
    piece2 = chess_board.square(tr, tc)
    if piece2 != ' ' && piece.color == piece2.color && piece.instance_of?(King) && piece2.instance_of?(Rook)
      if tc - fc == 3 && move_manager.can_castle_short?(current_player, piece, piece2) # hardcoded diffrentiator for long/short castle
        return [piece, piece2, 'short']
      elsif fc - tc == 4 && move_manager.can_castle_long?(current_player, piece, piece2)
        return [piece, piece2, 'long']
      else
        puts 'cant castle'
        return false
      end
    elsif left_en_passant_trigger(piece, tr, tc)
      return [piece] if move_manager.can_en_passant_left?(piece, move_manager.last_move)

      puts 'can\'t en_passant left'
      return false
    elsif right_en_passant_trigger(piece, tr, tc)
      return [piece] if move_manager.can_en_passant_right?(piece, move_manager.last_move)

      puts 'can\'t en_passant right'
      return false
    else
      unless move_manager.valid_move?(piece, tr, tc)
        puts "#{piece} cant move there"
        return false
      end

      unless move_manager.legal_move?(current_player, piece, tr, tc)
        puts 'illegal move'
        return false
      end
      return [piece, tr, tc]
    end
  end

  def determine_input_type(current_player) # performs series of tests on player's input returns info on piece and final destination
    input = valid_move_input(current_player)
    return 'save' if input == 'save'

    plyr_input_to_grid_input(input)
  end

  def left_en_passant_trigger(piece, tr, tc)
    return false unless piece.instance_of?(Pawn)
    return false unless chess_board.square(tr, tc) == ' '

    if piece.color == 'W'
      (tr - piece.row) == -1 && (tc - piece.column) == -1
    else
      (tr - piece.row) == 1 && (tc - piece.column) == -1
    end
  end

  def right_en_passant_trigger(piece, tr, tc)
    return false unless piece.instance_of?(Pawn)
    return false unless chess_board.square(tr, tc) == ' '

    if piece.color == 'W'
      (tr - piece.row) == -1 && (tc - piece.column) == 1
    else
      (tr - piece.row) == 1 && (tc - piece.column) == 1
    end
  end

  def move_according_to_type(move_type)
    piece, tr, tc = move_type # structure is hacky
    if tr.nil? && tc.nil?
      current_player.en_passant(piece, move_manager.last_move)
    elsif tc == 'long'
      current_player.long_castle(piece, tr)
    elsif tc == 'short'
      current_player.short_castle(piece, tr)
    else
      move_manager.make_move(current_player, piece, tr, tc)
    end
    chess_board.show
  end

  def keep_playing
    until checkmated?(current_player) || stalemated?(current_player)

      input_type = determine_input_type(current_player)
      if input_type == 'save'
        save_to_file(self)
        puts 'Saved !'
        break
      end
      fr, fc, tr, tc = input_type
      move_type = determine_move_type(fr, fc, tr, tc)
      next if move_type == false

      move_according_to_type(move_type)

      @current_player = swap_players
    end
  end

  def final_message
    if checkmated?(current_player)
      puts "#{swap_players.color} Won"
    elsif stalemated?(current_player)
      puts 'Draw'
    end
  end

  def play
    keep_playing
    final_message
  end

  def swap_players
    if current_player == pl_w
      pl_b
    else
      pl_w
    end
  end

  def checkmated?(player) # game should have this?
    move_manager.in_check?(chess_board.king(player.color)) && move_manager.mated?(player)
  end

  def stalemated?(player) # game should have this?
    !move_manager.in_check?(chess_board.king(player.color)) && move_manager.mated?(player)
  end
end
