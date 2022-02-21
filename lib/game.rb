# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
require_relative '../lib/move_manager'
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

  def ask_move_input(player)
    puts " #{player.color} enter move of form 'd2d4' "
    gets.chomp
  end

  def verify?(input)
    input.match?(/^[a-h][1-8][a-h][1-8]$/)
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

  def keep_playing
    until checkmated?(current_player) || stalemated?(current_player)

      fr, fc, tr, tc = plyr_input_to_grid_input(valid_move_input(current_player))

      unless piece_exist?(fr, fc)
        puts 'this square is empty'
        next
      end

      piece = chess_board.square(fr, fc)

      unless player_piece?(current_player, piece)
        puts 'this is not ur piece'
        next
      end

      unless move_manager.valid_move?(piece, tr, tc)
        puts "#{piece} cant move there"
        next
      end

      unless move_manager.legal_move?(current_player, piece, tr, tc)
        puts 'illegal move'
        next
      end

      move_manager.make_move(current_player, piece, tr, tc)

      @current_player = swap_players
    end
  end

  def final_message
    if checkmated?(current_player)
      puts "#{swap_players.color} Won"
    else
      puts 'Draw'
    end
  end

  def play
    chess_board.show
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

g = Game.new
g.play
