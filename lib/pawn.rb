# frozen_string_literal: true

require_relative '../lib/chess_piece'

# a chess pawn
class Pawn < ChessPiece
  attr_reader :color

  def to_s
    color == 'W' ? "\u265f" : "\u2659"
  end

  def move(to_row, to_column)
    if valid_moves.include?([to_row, to_column])
      chess_board.piece_movement(self, to_row, to_column)
      update_position(to_row, to_column)

      promote if can_promote?
    else
      puts "#{self.class} cant move there"
    end
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

  def can_promote?
    if color == 'B'
      row == 7
    else
      row == 0
    end
  end

  def promote
    # row and column are both updated before promote is run so promoted piece will have correct coordinates
    promotion_piece = chess_board.make_promotion_piece(color, row, column)
    chess_board.piece_movement(promotion_piece, row, column)
  end

  def adjacent_left?
    # check if left adj square has opp colored pawn
    left_adj = chess_board.square(row, column - 1)
    left_adj.instance_of?(Pawn) && left_adj.color != color
  end

  def adjacent_right?
    right_adj = chess_board.square(row, column + 1)
    right_adj.instance_of?(Pawn) && right_adj.color != color
  end

  def left_en_passant_move
    color == 'W' ? [row - 1, column - 1] : [row + 1, column - 1]
  end

  def can_left_en_passant?
    color == 'W' ? adjacent_left? && row == 3 : adjacent_left? && row == 4
  end

  def right_en_passant_move
    color == 'W' ? [row - 1, column + 1] : [row + 1, column + 1]
  end

  def can_right_en_passant?
    color == 'W' ? adjacent_right? && row == 3 : adjacent_right? && row == 4
  end

  def add_en_passant_move(possible)
    if can_left_en_passant?
      possible.push(left_en_passant_move)
    elsif can_right_en_passant?
      possible.push(right_en_passant_move)
    end
  end
end
