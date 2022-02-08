# frozen_string_literal: true

require_relative '../lib/chess_piece'
# a chess rook
class Rook < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265c" : "\u2656"
  end

  private

  def possible_moves
    possible = []
    steps = *(1..7)
    steps.each do |step|
      possible.push([row + step, column]) if chess_board.on_board?(row + step, column)
      break if chess_board.occupied_square?(row + step, column)
      # loop breaks as there is something in front so no more neighbor in that direction
    end

    steps.each do |step|
      possible.push([row - step, column]) if chess_board.on_board?(row - step, column)
      break if chess_board.occupied_square?(row - step, column)
    end

    steps.each do |step|
      possible.push([row, column + step]) if chess_board.on_board?(row, column + step)
      break if chess_board.occupied_square?(row, column + step)
    end

    steps.each do |step|
      possible.push([row, column - step]) if chess_board.on_board?(row, column - step)
      break if chess_board.occupied_square?(row, column - step)
    end

    possible
  end
end
