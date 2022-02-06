# frozen_string_literal: true

require_relative '../lib/horse'
require_relative '../lib/chess_board'
# a chess player
class Player
  attr_reader :chess_board, :color

  def initialize(col, chess_board)
    @color = col
    @chess_board = chess_board
  end

  def grid
    chess_board.grid
  end

  def move_horse(horse_row, horse_column, row_final, column_final)
    grid.each do |row|
      row.each do |square|
        if square.class == Horse && square.color == color
          if square.row == horse_row && square.column == horse_column
            square.move(row_final, column_final)
          end
        end
      end
    end
  end
end

cb = ChessBoard.new
pl = Player.new('W', cb)
pl.move_horse(7, 6, 5, 5)
pl.move_horse(5, 5, 3, 4)
pl.move_horse(3, 4, 1, 3)
pl.move_horse(1, 3, 0, 5)
