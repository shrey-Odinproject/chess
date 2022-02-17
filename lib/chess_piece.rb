# frozen_string_literal: true

# an abstract class
class ChessPiece
  attr_reader :color, :chess_board, :row, :column

  def initialize(col, chess_board, row, column)
    @color = col
    @chess_board = chess_board
    @row = row
    @column = column
  end

  def valid_moves
    # return array of cordinates that are valid to move to from all possible moves
    valid = []
    possible_moves.each do |r, c|
      if !chess_board.occupied_square?(r, c) # move to empty square
        valid.push([r, c])
      elsif chess_board.square(r, c).color != color # capture opp color piece
        valid.push([r, c])
      end
    end
    valid
  end

  def update_position(row_up, col_up) # shouldn't this be private? should this be here?
    @row = row_up
    @column = col_up
  end

  def can_promote?
    false
  end
end
