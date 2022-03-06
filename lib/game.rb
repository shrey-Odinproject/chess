# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
require_relative '../lib/move_manager'
require 'yaml'

# class that plays a round of chess
class Game
  attr_reader :chess_board, :pl_w, :pl_b, :move_manager, :current_player

  def initialize(c_b = ChessBoard.new)
    @chess_board = c_b
    @pl_b = Player.new('B')
    @pl_w = Player.new('W')
    @move_manager = MoveManager.new(chess_board)
    @current_player = pl_w
    @false_move_messages = ['this square is empty', 'this is not ur piece', 'can\'t castle', 'can\'t en_passant left',
                            'can\'t en_passant right', 'illegal move', false]
  end

  def to_s
    lm = move_manager.last_move
    %{
      #{chess_board.show}
      last_(non_castle/passant)move: #{lm[0]} moved from #{(lm[4] + 97).chr}#{8 - lm[3]} to #{(lm[2] + 97).chr}#{8 - lm[1]}
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
    Dir['saves/*'].each.with_index(1) { |file, idx| puts "#{idx} #{file}" }
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

  def valid_move_input(player)
    loop do
      input = ask_move_input(player)
      return input if verify?(input)

      puts 'invalid form of input'
    end
  end

  def determine_move_type(fr, fc, tr, tc) # can be broken down
    return 'this square is empty' unless piece_exist?(fr, fc)

    # returns differ based on move type (hacky)
    piece = chess_board.square(fr, fc)
    return 'this is not ur piece' unless player_piece?(current_player, piece)

    # braching of noarmal/castle move
    piece2 = chess_board.square(tr, tc)

    if left_en_passant_trigger(piece, tr, tc) # en passant branch (feel should be checked before castling)
      return [piece] if move_manager.can_en_passant_left?(piece, move_manager.last_move)

      'can\'t en_passant left'
    elsif right_en_passant_trigger(piece, tr, tc)
      return [piece] if move_manager.can_en_passant_right?(piece, move_manager.last_move)

      'can\'t en_passant right'
    elsif castle_trigger?(piece, piece2)
      if tc - fc == 3 && move_manager.can_castle_short?(current_player, piece, piece2) # hardcoded diffrentiator for long/short castle
        [piece, piece2, 'short']
      elsif fc - tc == 4 && move_manager.can_castle_long?(current_player, piece, piece2)
        [piece, piece2, 'long']
      else
        'can\'t castle'
      end
    else
      unless move_manager.valid_move?(piece, tr, tc)
        puts "#{piece} can\'t move there"
        return false # return piece and message becomes complex so simply returning false
      end

      return 'illegal move' unless move_manager.legal_move?(current_player, piece, tr, tc)

      [piece, tr, tc]
    end
  end

  def determine_input_type(current_player)
    input = valid_move_input(current_player)
    return 'save' if input == 'save'
    return 'resign' if input == 'resign'

    plyr_input_to_grid_input(input) # it is a 'move' input
  end

  def display_move_type_response(move_type)
    case move_type
    when 'this square is empty'
      puts 'this square is empty'
    when 'this is not ur piece'
      puts 'this is not ur piece'
    when 'can\'t castle'
      puts 'can\'t castle'
    when 'can\'t en_passant left'
      puts 'can\'t en_passant left'
    when 'can\'t en_passant right'
      puts 'can\'t en_passant right'
    when 'illegal move'
      puts 'illegal move'
    end
  end

  def keep_playing
    until checkmated?(current_player) || stalemated?(current_player)

      input_type = determine_input_type(current_player)
      if input_type == 'save'
        save_to_file(self)
        puts 'Saved !'
        break
      elsif input_type == 'resign'
        return 2211
      end
      fr, fc, tr, tc = input_type
      move_type = determine_move_type(fr, fc, tr, tc)
      if @false_move_messages.include?(move_type)
        display_move_type_response(move_type)
        next
      end

      move_according_to_type(move_type)

      @current_player = swap_players
    end
  end

  def play
    match_result = keep_playing
    final_message(match_result)
  end

  private

  def ask_move_input(player)
    print "#{player.color} enter move of form 'd2d4': "
    gets.chomp
  end

  def verify?(input)
    input.match?(/^[a-h][1-8][a-h][1-8]$/) || input == 'save' || input == 'resign'
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

  def final_message(match_result)
    if checkmated?(current_player)
      puts "#{swap_players.color} Won"
    elsif stalemated?(current_player)
      puts 'Draw'
    elsif match_result == 2211
      puts "#{current_player.color} resigned!! #{swap_players.color} Won"
    end
  end

  def move_according_to_type(move_type)
    piece, tr, tc = move_type
    move_manager.make_move(current_player, piece, tr, tc)
    chess_board.show
  end

  def piece_exist?(from_row, from_column) # game should have this?
    chess_board.occupied_square?(from_row, from_column)
  end

  def player_piece?(player, piece) # game should have this?
    piece.color == player.color
  end

  def left_en_passant_trigger(piece, tr, tc)
    return false unless piece.instance_of?(Pawn)
    return false if piece_exist?(tr, tc)

    if piece.color == 'W'
      (tr - piece.row) == -1 && (tc - piece.column) == -1
    else
      (tr - piece.row) == 1 && (tc - piece.column) == -1
    end
  end

  def right_en_passant_trigger(piece, tr, tc)
    return false unless piece.instance_of?(Pawn)
    return false if piece_exist?(tr, tc)

    if piece.color == 'W'
      (tr - piece.row) == -1 && (tc - piece.column) == 1
    else
      (tr - piece.row) == 1 && (tc - piece.column) == 1
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

  def castle_trigger?(piece, piece2)
    piece2 != ' ' && piece.color == piece2.color && piece.instance_of?(King) && piece2.instance_of?(Rook)
  end
end
