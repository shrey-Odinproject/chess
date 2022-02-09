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
pl.move_piece(6, 3, 4, 3)
ply.move_piece(3, 4, 4, 3)
pl.move_piece(7, 3, 4, 3)
