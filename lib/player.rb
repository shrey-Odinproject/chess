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
    chess_board.grid.each do |row|
      row.each do |square|
        square.move(to_row, to_column) if target_square?(square, from_row, from_column)
      end
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

pl.move_piece(6, 4, 5, 4)
ply.move_piece(1, 4, 2, 4)
pl.move_piece(5, 4, 4, 4)
ply.move_piece(1, 3, 2, 3)
pl.move_piece(4, 4, 3, 3)
ply.move_piece(2, 3, 3, 3)
