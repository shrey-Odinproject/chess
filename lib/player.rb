# frozen_string_literal: true

require_relative '../lib/chess_board'
# a chess player
class Player
  attr_reader :chess_board, :color

  def initialize(col, chess_board)
    @color = col
    @chess_board = chess_board
  end

  def move_piece(piece_type, from_row, from_column, to_row, to_column)
    chess_board.grid.each do |row|
      row.each do |square|
        square.move(to_row, to_column) if target_square?(square, piece_type, from_row, from_column)
      end
    end
  end

  private

  def target_square?(square, piece_type, row, col)
    # helps targetting a specific piece on board to move
    return false unless square.instance_of?(piece_type)
    return false unless square.color == color
    return false unless square.row == row
    return false unless square.column == col

    true
  end
end

cb = ChessBoard.new
pl = Player.new('W', cb)
ply = Player.new('B', cb)

pl.move_piece(Horse, 7, 6, 5, 5)

ply.move_piece(King, 0, 4, 1, 5)

ply.move_piece(King, 1, 5, 2, 4)
