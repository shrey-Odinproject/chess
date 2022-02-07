# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess horse
class Horse < ChessPiece
  def to_s
    color == 'W' ? "\u265e" : "\u2658"
  end

  private

  def possible_moves
    # all the moves that are on board (despite square being occupied by horse's teammate)
    n1 = [row + 1, column + 2] if chess_board.on_board?(row + 1, column + 2)
    n2 = [row + 1, column - 2] if chess_board.on_board?(row + 1, column - 2)
    n3 = [row - 1, column + 2] if chess_board.on_board?(row - 1, column + 2)
    n4 = [row - 1, column - 2] if chess_board.on_board?(row - 1, column - 2)

    n5 = [row + 2, column + 1] if chess_board.on_board?(row + 2, column + 1)
    n6 = [row + 2, column - 1] if chess_board.on_board?(row + 2, column - 1)
    n7 = [row - 2, column + 1] if chess_board.on_board?(row - 2, column + 1)
    n8 = [row - 2, column - 1] if chess_board.on_board?(row - 2, column - 1)

    [n1, n2, n3, n4, n5, n6, n7, n8] - [nil]
  end
end
