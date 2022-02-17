# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
# a chess game
class MoveManager
  attr_reader :chess_board, :pl_b, :pl_w

  def initialize
    @chess_board = ChessBoard.new('1B1q4/2P1K3/4n3/8/6k1/6r1/8/N7')
    @pl_w = Player.new('W')
    @pl_b = Player.new('B')
  end

  def make_legal_move(player, from_row, from_column, to_row, to_column)
    return puts 'this square is empty' unless chess_board.occupied_square?(from_row, from_column)

    piece = chess_board.square(from_row, from_column)
    return puts 'this is not ur piece' if piece.color != player.color

    if piece.valid_moves.include?([to_row, to_column])
      if legal_move?(player, from_row, from_column, to_row, to_column)
        player.move_piece(piece, to_row, to_column)
        promote(piece) if piece.can_promote?
        chess_board.show
      else
        puts 'illegal move'
      end
    else
      puts "#{piece.class} cant move there"
    end
  end

  private

  def legal_move?(player, from_row, from_column, to_row, to_column)
    # makes move we tryna make on a copy of current board and sees if king is safe or not after the move
    copy_board = Marshal.load(Marshal.dump(chess_board)) # using a deepcopy seems to work for now(clone/dup fail despite change in obj id)
    copy_player = Player.new(player.color)
    copy_piece = copy_board.square(from_row, from_column)

    copy_player.move_piece(copy_piece, to_row, to_column) # move piece on copy and see king's status
    in_check?(king(copy_player.color, copy_board), copy_board) == false
  end

  def king(color, chess_board)
    chess_board.all_squares.each do |sq|
      return sq if sq.instance_of?(King) && sq.color == color
    end
  end

  def in_check?(king, chess_board)
    chess_board.all_squares.each do |sq|
      if sq != ' ' && sq.color != king.color && sq.valid_moves.include?([king.row, king.column])
        puts "CHECK !! #{king} is under attack by #{sq}"
        return true # returns for 1st piece it finds which checks king
      end
    end
    false
  end

  def promote(pawn)
    # row and column are both updated before promote is run so promoted piece will have correct coordinates
    promotion_piece = chess_board.make_promotion_piece(pawn.color, pawn.row, pawn.column)
    chess_board.piece_movement(promotion_piece, pawn.row, pawn.column)
  end
end

mm = MoveManager.new
mm.make_legal_move(mm.pl_w, 1, 2, 0, 3) # pawn promotes
mm.make_legal_move(mm.pl_w, 0, 3, 2, 2) # valid move only if promoted to horse
mm.make_legal_move(mm.pl_w, 4, 6, 5, 6) # enemy piece
mm.make_legal_move(mm.pl_b, 4, 1, 5, 6) # empty square
mm.make_legal_move(mm.pl_b, 4, 6, 4, 5) # illegal as king goes in check
