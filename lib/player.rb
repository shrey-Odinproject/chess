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
    piece.has_moved_before = true
  end

  def short_castle(king, rook) # 'king moves 2 steps towards rook' cant implement that so hardcoded column +2/-2
    move_piece(king, king.row, king.column + 2)
    move_piece(rook, king.row, king.column - 1) # hardcoded 'next to king' column +1/-1
  end

  def long_castle(king, rook)
    move_piece(king, king.row, king.column - 2)
    move_piece(rook, king.row, king.column + 1)
  end
end
