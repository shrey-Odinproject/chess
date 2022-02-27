# frozen_string_literal: true

# a chess move manager
class MoveManager
  attr_reader :chess_board

  def initialize(chess_board)
    @chess_board = chess_board
  end

  def valid_move?(piece, to_row, to_column) # make_legal_move pt
    piece.valid_moves.include?([to_row, to_column])
  end

  def make_move(player, piece, to_row, to_column) # make_legal_move pt
    player.move_piece(piece, to_row, to_column)
    promote(piece) if piece.can_promote?
  end

  # private

  def mated?(player)
    chess_board.all_pieces(player.color).each do |p_piece| # for all your pieces
      p_piece.valid_moves.each do |row, col| # for each valid move of that piece
        copy_board = Marshal.load(Marshal.dump(chess_board)) # we run a simulation of the move
        copy_piece = copy_board.square(p_piece.row, p_piece.column)
        player.move_piece(copy_piece, row, col)
        return false unless in_check?(copy_board.king(player.color), copy_board) # see if king in check after move
      end
    end
    true # after trying all possible move king still in check
  end

  def legal_move?(player, piece, to_row, to_column)
    # makes move we tryna make on a copy of current board and sees if king is safe or not after the move
    copy_board = Marshal.load(Marshal.dump(chess_board)) # using a deepcopy seems to work for now(clone/dup fail despite change in obj id)
    copy_piece = copy_board.square(piece.row, piece.column)

    player.move_piece(copy_piece, to_row, to_column) # move piece on copy and see king's status
    in_check?(copy_board.king(player.color), copy_board) == false
  end

  def in_check?(king, chess_board = self.chess_board)
    chess_board.all_squares.each do |sq|
      if sq != ' ' && sq.color != king.color && sq.valid_moves.include?([king.row, king.column])
        # puts "CHECK !! #{king} is under attack by #{sq}" # used for debugging
        return true # returns for 1st piece it finds which checks king
      end
    end
    false
  end

  def promote(pawn) # should this be handled by move manager?
    # row and column are both updated before promote is run so promoted piece will have correct coordinates
    promotion_piece = chess_board.make_promotion_piece(pawn.color, pawn.row, pawn.column)
    chess_board.piece_movement(promotion_piece, pawn.row, pawn.column)
  end

  def short_castle_path_clear?(king)
    !chess_board.occupied_square?(king.row, 5) && !chess_board.occupied_square?(king.row, 6)
  end

  def long_catsle_path_clear?(king)
    !chess_board.occupied_square?(king.row,
                                  1) && !chess_board.occupied_square?(king.row,
                                                                      2) && !chess_board.occupied_square?(king.row, 3)
  end

  def short_path_under_attack?(king)
    path = [[king.row, 5], [king.row, 6]]
    path.each do |path_sq|
      chess_board.all_squares.each do |sq|
        return true if sq != ' ' && sq.color != king.color && sq.valid_moves.include?(path_sq)
      end
    end
    false
  end

  def long_path_under_attack?(king)
    path = [[king.row, 1], [king.row, 2], [king.row, 3]]
    path.each do |path_sq|
      chess_board.all_squares.each do |sq|
        return true if sq != ' ' && sq.color != king.color && sq.valid_moves.include?(path_sq)
      end
    end
    false
  end

  def king_safe_after_short_castle?(player, king, short_rook)
    copy_board = Marshal.load(Marshal.dump(chess_board))
    copy_king = copy_board.king(king.color)
    copy_short_rook = copy_board.square(short_rook.row, short_rook.column)
    player.short_castle(copy_king, copy_short_rook)
    in_check?(copy_board.king(player.color), copy_board) == false
  end

  def king_safe_after_long_castle?(player, king, long_rook)
    copy_board = Marshal.load(Marshal.dump(chess_board))
    copy_king = copy_board.king(king.color)
    copy_long_rook = copy_board.square(long_rook.row, long_rook.column)
    player.long_castle(copy_king, copy_long_rook)
    in_check?(copy_board.king(player.color), copy_board) == false
  end

  def king_rook_not_moved?(king, rook)
    king.has_moved_before == false && rook.has_moved_before == false
  end

  def can_castle_short?(player, king, rook)
    unless king_rook_not_moved?(king, rook)
      puts 'rook/king moved'
      return false
    end
    if in_check?(king)
      puts ' king in check'
      return false
    end
    unless short_castle_path_clear?(king)
      puts 'short castle path not clear'
      return false
    end
    if short_path_under_attack?(king)
      puts 'short castle path undr attack'
      return false
    end
    unless king_safe_after_short_castle?(player, king, rook)
      puts 'king unsafe after castle'
      return false
    end

    true
  end

  def can_castle_long?(player, king, rook)
    unless king_rook_not_moved?(king, rook)
      puts 'rook/king moved'
      return false
    end
    if in_check?(king)
      puts ' king in check'
      return false
    end
    unless long_catsle_path_clear?(king)
      puts 'long castle path not clear'
      return false
    end
    if long_path_under_attack?(king)
      puts 'long castle path undr attack'
      return false
    end
    unless king_safe_after_long_castle?(player, king, rook)
      puts 'king unsafe after castle'
      return false
    end

    true
  end
end
