# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess king
class King < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265A" : "\u2654"
  end

  private

  def possible_moves
    possible = []

    possible.push([row + 1, column]) if chess_board.on_board?(row + 1, column)
    possible.push([row - 1, column]) if chess_board.on_board?(row - 1, column)
    possible.push([row, column + 1]) if chess_board.on_board?(row, column + 1)
    possible.push([row, column - 1]) if chess_board.on_board?(row, column - 1)

    possible.push([row + 1, column + 1]) if chess_board.on_board?(row + 1, column + 1)
    possible.push([row - 1, column + 1]) if chess_board.on_board?(row - 1, column + 1)
    possible.push([row - 1, column - 1]) if chess_board.on_board?(row - 1, column - 1)
    possible.push([row + 1, column - 1]) if chess_board.on_board?(row + 1, column - 1)

    possible
  end
end
