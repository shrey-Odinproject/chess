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
end
