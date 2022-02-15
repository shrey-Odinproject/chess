# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
# a chess game
class ChessGame
  attr_reader :chess_board, :pl_b, :pl_w

  def initialize
    @chess_board = ChessBoard.new
    @pl_w = Player.new('W', chess_board)
    @pl_b = Player.new('B', chess_board)
  end
end

cg = ChessGame.new
cg.pl_b.move_piece(1, 4, 3, 4)

cg.pl_w.move_piece(6, 3, 4, 3)
cg.pl_w.move_piece(7, 1, 5, 2)
cg.pl_w.move_piece(6, 2, 4, 2)
