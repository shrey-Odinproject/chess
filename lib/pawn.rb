# frozen_string_literal: true

require_relative '../lib/chess_piece'

# a chess pawn
class Pawn < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265f" : "\u2659"
  end

  def can_promote? # should this be here too ?
    color == 'B' ? row == 7 : row == 0
  end

  def on_passant_rank?
    color == 'B' ? row == 4 : row == 3
  end

  private

  def possible_moves
    possible = []
    if color == 'B'

      if row == 1 && chess_board.on_board?(row + 2,
                                           column) && !chess_board.occupied_square?(row + 2,
                                                                                    column) && !chess_board.occupied_square?(
                                                                                      row + 1, column
                                                                                    )
        possible.push([row + 2, column]) # 2 step on firstmove
      end

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

      if row == 6 && chess_board.on_board?(row - 2,
                                           column) && !chess_board.occupied_square?(row - 2,
                                                                                    column) && !chess_board.occupied_square?(
                                                                                      row - 1, column
                                                                                    )
        possible.push([row - 2, column]) # 2 step on firstmove
      end

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

    # add_en_passant_move(possible)
    possible
  end
end
