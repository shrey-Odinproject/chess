# frozen_string_literal: true

require_relative '../lib/chess_board'
require_relative '../lib/player'
# a chess game
class ChessGame
  attr_reader :chess_board, :pl_b, :pl_w

  def initialize
    @chess_board = ChessBoard.new('8/P2k3r/3r4/8/2K5/4B1R1/8/N7')
    @pl_w = Player.new('W', chess_board)
    @pl_b = Player.new('B', chess_board)
  end

  def validate_move_piece(player, from_row, from_column, to_row, to_column)
    piece = chess_board.square(from_row, from_column)

    return puts 'this square is empty' if piece == ' '
    return puts " #{player} this is not ur piece" if piece.color != player.color

    player.move_piece(piece, to_row, to_column) unless in_check?(king(player.color))
  end

  private

  def king(color)
    chess_board.all_squares.each do |sq|
      return sq if sq.instance_of?(King) && sq.color == color
    end
  end

  def in_check?(king)
    chess_board.all_squares.each do |sq|
      if sq != ' ' && sq.color != king.color && sq.valid_moves.include?([king.row, king.column])
        chess_board.show
        puts " CHECK !! #{king} is under attack by #{sq}"
        return true # returns for 1st piece it finds which checks king
      end
    end
    false
  end
end

cg = ChessGame.new
cg.validate_move_piece(cg.pl_w, 1, 0, 0, 0)
