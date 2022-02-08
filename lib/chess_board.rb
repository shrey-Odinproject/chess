# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/rook'
require_relative '../lib/bishop'
require_relative '../lib/horse'
# a chess board
class ChessBoard
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, ' ') }
    setup_board
  end

  def show
    puts <<-HEREDOC
          ---+---+---+---+---+---+---+---
        8| #{@grid[0][0]} | #{@grid[0][1]} | #{@grid[0][2]} | #{@grid[0][3]} | #{@grid[0][4]} | #{@grid[0][5]} | #{@grid[0][6]} | #{@grid[0][7]} |
          ---+---+---+---+---+---+---+---
        7| #{@grid[1][0]} | #{@grid[1][1]} | #{@grid[1][2]} | #{@grid[1][3]} | #{@grid[1][4]} | #{@grid[1][5]} | #{@grid[1][6]} | #{@grid[1][7]} |
          ---+---+---+---+---+---+---+---
        6| #{@grid[2][0]} | #{@grid[2][1]} | #{@grid[2][2]} | #{@grid[2][3]} | #{@grid[2][4]} | #{@grid[2][5]} | #{@grid[2][6]} | #{@grid[2][7]} |
          ---+---+---+---+---+---+---+---
        5| #{@grid[3][0]} | #{@grid[3][1]} | #{@grid[3][2]} | #{@grid[3][3]} | #{@grid[3][4]} | #{@grid[3][5]} | #{@grid[3][6]} | #{@grid[3][7]} |
          ---+---+---+---+---+---+---+---
        4| #{@grid[4][0]} | #{@grid[4][1]} | #{@grid[4][2]} | #{@grid[4][3]} | #{@grid[4][4]} | #{@grid[4][5]} | #{@grid[4][6]} | #{@grid[4][7]} |
          ---+---+---+---+---+---+---+---
        3| #{@grid[5][0]} | #{@grid[5][1]} | #{@grid[5][2]} | #{@grid[5][3]} | #{@grid[5][4]} | #{@grid[5][5]} | #{@grid[5][6]} | #{@grid[5][7]} |
          ---+---+---+---+---+---+---+---
        2| #{@grid[6][0]} | #{@grid[6][1]} | #{@grid[6][2]} | #{@grid[6][3]} | #{@grid[6][4]} | #{@grid[6][5]} | #{@grid[6][6]} | #{@grid[6][7]} |
          ---+---+---+---+---+---+---+---
        1| #{@grid[7][0]} | #{@grid[7][1]} | #{@grid[7][2]} | #{@grid[7][3]} | #{@grid[7][4]} | #{@grid[7][5]} | #{@grid[7][6]} | #{@grid[7][7]} |
          ---+---+---+---+---+---+---+---
           a   b   c   d   e   f   g   h
    HEREDOC
  end

  def occupied_square?(row, col)
    grid[row][col] != ' '
  end

  def on_board?(row, column)
    return true if [row, column].all? { |num| num <= 7 && num >= 0 }

    false
  end

  def move_piece_on_board(piece, row_final, column_final)
    edit_square(piece.row, piece.column, ' ') # take piece from
    edit_square(row_final, column_final, piece) # take piece to
  end

  private

  def edit_square(row, col, val)
    grid[row][col] = val
  end

  def setup_pawns
    grid.each_with_index do |row, i|
      row.each_with_index do |_square, j|
        grid[i][j] = Pawn.new('B') if i == 1
        grid[i][j] = Pawn.new('W') if i == 6
      end
    end
  end

  def setup_kings
    grid[7][4] = King.new('W')
    grid[0][4] = King.new('B')
  end

  def setup_queens
    grid[7][3] = Queen.new('W')
    grid[0][3] = Queen.new('B')
  end

  def setup_rooks
    grid[7][0] = Rook.new('W', self, 7, 0)
    grid[7][7] = Rook.new('W', self, 7, 7)

    grid[0][0] = Rook.new('B', self, 0, 0)
    grid[0][7] = Rook.new('B', self, 0, 7)
  end

  def setup_bishops
    grid[7][2] = Bishop.new('W', self, 7, 2)
    grid[7][5] = Bishop.new('W', self, 7, 5)

    grid[0][2] = Bishop.new('B', self, 0, 2)
    grid[0][5] = Bishop.new('B', self, 0, 5)
  end

  def setup_horses
    grid[7][1] = Horse.new('W', self, 7, 1)
    grid[7][6] = Horse.new('W', self, 7, 6)

    grid[0][1] = Horse.new('B', self, 0, 1)
    grid[0][6] = Horse.new('B', self, 0, 6)
  end

  def setup_board
    setup_pawns
    setup_kings
    setup_queens
    setup_rooks
    setup_bishops
    setup_horses
  end
end
