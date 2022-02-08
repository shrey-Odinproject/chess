# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess pawn
class Pawn < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265f" : "\u2659"
  end

  private

  def possible_moves
    possible = []
    if color == 'B'

      if chess_board.on_board?(row + 1, column) && !chess_board.occupied_square?(row + 1, column)
        # move only if nothing in front
        possible.push([row + 1, column])
      end

      if chess_board.on_board?(row + 1, column - 1) && chess_board.occupied_square?(row + 1, column - 1)
        # capture piece diag left
        possible.push([row + 1, column - 1])
      end

      if chess_board.on_board?(row + 1, column + 1) && chess_board.occupied_square?(row + 1, column + 1)
        # capture piece diag right
        possible.push([row + 1, column + 1])
      end
    else
      if chess_board.on_board?(row - 1, column) && !chess_board.occupied_square?(row - 1, column)
        # move only if nothing in front
        possible.push([row - 1, column])
      end

      if chess_board.on_board?(row - 1, column - 1) && chess_board.occupied_square?(row - 1, column - 1)
        # capture piece diag left
        possible.push([row - 1, column - 1])
      end

      if chess_board.on_board?(row - 1, column + 1) && chess_board.occupied_square?(row - 1, column + 1)
        # capture piece diag right
        possible.push([row - 1, column + 1])
      end
    end
    possible
  end
end
