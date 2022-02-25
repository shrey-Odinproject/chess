creating chess using OOP concepts
-- all the spare en passant code that is unused rn

# def on_passant_rank?
  #   color == 'B' ? row == 4 : row == 3
  # end

# def passant_capture(pawn, victim)
  #   # this wil run with after the normal passant diagonal to show 'capture'
  #   # this method only edits board and not updates piece's row/column attr
  #   chess_board.piece_movement(pawn, victim.row, victim.column)
  #   if pawn.color == 'W'
  #     chess_board.piece_movement(pawn, victim.row - 1, victim.column)
  #   else
  #     chess_board.piece_movement(pawn, victim.row + 1, victim.column)
  #   end
  # end

# def adjacent_left?
  #   # check if left adj square has opp colored pawn
  #   left_adj = chess_board.square(row, column - 1)
  #   left_adj.instance_of?(Pawn) && left_adj.color != color
  # end

  # def adjacent_right?
  #   right_adj = chess_board.square(row, column + 1)
  #   right_adj.instance_of?(Pawn) && right_adj.color != color
  # end

  # def left_en_passant_move
  #   color == 'W' ? [row - 1, column - 1] : [row + 1, column - 1]
  # end

  # def can_left_en_passant?
  #   color == 'W' ? adjacent_left? && row == 3 : adjacent_left? && row == 4
  # end

  # def right_en_passant_move
  #   color == 'W' ? [row - 1, column + 1] : [row + 1, column + 1]
  # end

  # def can_right_en_passant?
  #   color == 'W' ? adjacent_right? && row == 3 : adjacent_right? && row == 4
  # end

  # def add_en_passant_move(possible)
  #   if can_left_en_passant?
  #     possible.push(left_en_passant_move)
  #   elsif can_right_en_passant?
  #     possible.push(right_en_passant_move)
  #   end
  # end
