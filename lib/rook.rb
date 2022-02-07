# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess rook
class Rook < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265c" : "\u2656"
  end

  def possible_moves
    possible = []
    steps = *(1..7)
    steps.each do |step|
      possible.push([row + step, column]) if chess_board.on_board?(row + step, column)
      possible.push([row - step, column]) if chess_board.on_board?(row - step, column)
      possible.push([row, column + step]) if chess_board.on_board?(row, column + step)
      possible.push([row, column - step]) if chess_board.on_board?(row, column - step)
    end
    possible

    # if pawn in front of rook eg rook at 0,0 and pawn at 1,0
    # rooks valid move become 2,0 --- 7,0 which is false cause pawn blocks its vision
  end
end
