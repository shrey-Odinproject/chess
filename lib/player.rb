# frozen_string_literal: true

# a chess player
class Player
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def move_piece(piece, to_row, to_column) # moved from chess piece to here (for now)
    piece.chess_board.piece_movement(piece, to_row, to_column) # should this be done by another class?
    piece.update_position(to_row, to_column) # shouldnt update position be  private
  end
end
