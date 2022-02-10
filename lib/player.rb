# frozen_string_literal: true

require_relative '../lib/chess_board'
# a chess player
class Player
  attr_reader :chess_board, :color

  def initialize(col, chess_board)
    @color = col
    @chess_board = chess_board
  end

  def move_piece(from_row, from_column, to_row, to_column)
    chess_board.all_squares.each do |square|
      square.move(to_row, to_column) if target_square?(square, from_row, from_column)
    end
  end

  private

  def target_square?(square, row, col)
    # helps targetting a specific piece on board to move
    return false if square == ' ' # u cant target an empty square
    return false unless square.color == color # piece of ur color
    return false unless square.row == row # coordinates of piece
    return false unless square.column == col

    true
  end
end

cb = ChessBoard.new
pl = Player.new('W', cb)
ply = Player.new('B', cb)

ply.move_piece(1, 4, 3, 4)
# ply.move_piece(1, 2, 3, 2)
pl.move_piece(6, 3, 4, 3)
pl.move_piece(4, 3, 3, 3) # now en pessant possible for pl in next move
pl.move_piece(6,0,5,0) # move another piece (now cannot en passant)
pl.move_piece(3,3,2,4) # am still able to take en passant !! why?

# pl.move_piece(3,3,2,3)
# pl.move_piece(3, 3, 2, 2)
# pl.move_piece(2, 2, 1, 2)
# pl.move_piece(1, 2, 0, 1)
