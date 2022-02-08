# frozen_string_literal: true

# an abstract class
class ChessPiece
  attr_reader :color, :chess_board
  attr_accessor :row, :column

  def initialize(col, chess_board, row, column)
    @color = col
    @chess_board = chess_board
    @row = row
    @column = column
  end

  def move(to_row, to_column)
    if valid_moves.include?([to_row, to_column])
      chess_board.move_piece_on_board(self, to_row, to_column)
      update_position(to_row, to_column)
      chess_board.show
    else
      puts "#{self.class} cant move there"
    end
  end

  private

  def update_position(row_up, col_up)
    self.row = row_up
    self.column = col_up
  end

  def valid_moves
    # return array of cordinates that are valid to move to from all possible moves
    valid = []
    possible_moves.each do |r, c|
      if !chess_board.occupied_square?(r, c) # move to empty square
        valid.push([r, c])
      elsif chess_board.grid[r][c].color != color # capture opp color piece
        valid.push([r, c])
      end
    end
    p valid
  end
end
