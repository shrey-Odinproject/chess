# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
require_relative '../lib/move_manager'
# a dummy game class that plays a round of chess
class Game
  attr_accessor :chess_board, :pl_w, :pl_b, :move_manager, :current_player

  def initialize
    @chess_board = ChessBoard.new
    @pl_b = Player.new('B')
    @pl_w = Player.new('W')
    @move_manager = MoveManager.new(chess_board)
    @current_player = pl_w
  end

  def ask_move_input
    puts 'enter frm r, frm c, to r, to c'
    gets.chomp
  end

  def get_moves
    moves = []
    input = ask_move_input
    input.chars.each do |letr|
      moves.push(letr.to_i)
    end
    moves
  end

  def play
    until move_manager.checkmated?(current_player) || move_manager.stalemated?(current_player)
      puts "#{current_player.color}'s turn"
      fr, fc, tr, tc = get_moves
      move = move_manager.make_legal_move(current_player, fr, fc, tr, tc)

      self.current_player = swap_players if move
    end
  end

  def swap_players
    if current_player == pl_w
      pl_b
    else
      pl_w
    end
  end
end

g = Game.new
g.play

# moves for fools mate
# w- 6555, 6646
# b- 1424, 0347
