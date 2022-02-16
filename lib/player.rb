# frozen_string_literal: true

# a chess player
class Player
  attr_reader :chess_board, :color

  def initialize(col, chess_board)
    @color = col
    @chess_board = chess_board
  end

  def move_piece(piece, to_row, to_column)
    piece.move(to_row, to_column)
  end
end
