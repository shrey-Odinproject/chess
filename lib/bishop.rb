# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess bishop
class Bishop < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265d" : "\u2657"
  end

  private

  def possible_moves
    possible = []
    steps = *(1..7)

    steps.each do |step|
      if chess_board.on_board?(row + step, column + step)
        possible.push([row + step, column + step])
        break if chess_board.occupied_square?(row + step, column + step)
      end
    end

    steps.each do |step|
      if chess_board.on_board?(row - step, column - step)
        possible.push([row - step, column - step])
        break if chess_board.occupied_square?(row - step, column - step)
      end
    end

    steps.each do |step|
      if chess_board.on_board?(row - step, column + step)
        possible.push([row - step, column + step])
        break if chess_board.occupied_square?(row - step, column + step)
      end
    end

    steps.each do |step|
      if chess_board.on_board?(row + step, column - step)
        possible.push([row + step, column - step])
        break if chess_board.occupied_square?(row + step, column - step)
      end
    end

    possible
  end
end
