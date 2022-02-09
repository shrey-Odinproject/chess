# frozen_string_literal: true

require_relative '../lib/chess_piece'
require_relative '../lib/queen'
require_relative '../lib/horse'
require_relative '../lib/rook'
require_relative '../lib/bishop'
# a chess pawn
class Pawn < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265f" : "\u2659"
  end

  def move(to_row, to_column)
    if valid_moves.include?([to_row, to_column])
      chess_board.show_piece_movement(self, to_row, to_column)
      update_position(to_row, to_column)

      promote(to_row, to_column) if can_promote?

      chess_board.show
    else
      puts "#{self.class} cant move there"
    end
  end

  private

  def possible_moves
    possible = []
    if color == 'B'

      if row == 1 && chess_board.on_board?(row + 2, column) && !chess_board.occupied_square?(row + 2, column)
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

      if row == 6 && chess_board.on_board?(row - 2, column) && !chess_board.occupied_square?(row - 2, column)
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
    possible
  end

  def can_promote?
    if color == 'B'
      row == 7
    else
      row == 0
    end
  end

  def get_choice # this is also doubtful of belonging here 
    puts ' u can promote to H orse,B ishop,Q ueen,R ook'
    gets.chomp
  end

  def make_promotion_piece # should this belong in pawn?
    case get_choice
    when 'Q'
      Queen.new(color, chess_board, row, column)
    when 'H'
      Horse.new(color, chess_board, row, column)
    when 'R'
      Rook.new(color, chess_board, row, column)
    when 'B'
      Bishop.new(color, chess_board, row, column)
    end
  end

  def promote(to_row, to_column)
    promotion_piece = make_promotion_piece
    chess_board.show_piece_movement(promotion_piece, to_row, to_column)
  end
end
