# frozen_string_literal: true

# a chess player
class Player
  attr_reader :chess_board, :color

  def initialize(col, chess_board)
    @color = col
    @chess_board = chess_board
  end

  def move_piece(from_row, from_column, to_row, to_column)
    # checking weather coordinates are valid wont happen here, here we assume arguments given are valid
    # that checking needs to be seprate
    piece = chess_board.square(from_row, from_column)
    return p 'this square is empty' if piece == ' ' # this needs to be seprate

    if piece.color == color
      piece.move(to_row, to_column)
      chess_board.show
    else
      p "pl_#{color} this is not ur piece" # this needs to be seprate
    end
  end
end
