# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/rook'
require_relative '../lib/bishop'
require_relative '../lib/horse'
# a chess board
class ChessBoard
  DICT = {
    'r' => Rook,
    'n' => Horse,
    'k' => King,
    'q' => Queen,
    'b' => Bishop,
    'p' => Pawn,

    'R' => Rook,
    'N' => Horse,
    'K' => King,
    'Q' => Queen,
    'B' => Bishop,
    'P' => Pawn,

    ' ' => ' '

  }.freeze
  def initialize(fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
    @grid = Array.new(8) { Array.new(8, ' ') }
    setup_board(fen) # takes in an fen , has default board fen as arg if none passed
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

  def square(row, col)
    @grid[row][col]
  end

  def occupied_square?(row, col)
    square(row, col) != ' '
  end

  def on_board?(row, column)
    return true if [row, column].all? { |num| num <= 7 && num >= 0 }

    false
  end

  def piece_movement(piece, row_final, column_final)
    edit_square(piece.row, piece.column, ' ') # take piece from
    edit_square(row_final, column_final, piece) # take piece to
  end

  def all_squares
    # array of objects present on each square eg ' ' or Horse obj etc
    squares = []
    indxs = *(0..7)
    indxs.each do |row|
      indxs.each do |col|
        squares.push(square(row, col))
      end
    end
    squares
  end

  def ask_choice # (moved to here from pawn)
    puts ' u can promote to H orse, B ishop, Q ueen, R ook'
    gets.chomp
  end

  def promotion_choice
    loop do
      input = ask_choice
      return input if ['Q', 'H', 'R', 'B'].include?(input)

      puts ' not a valid piece choice'
    end
  end

  def make_promotion_piece(color, row, column) # (moved to here from pawn)
    case promotion_choice
    when 'Q'
      Queen.new(color, self, row, column)
    when 'H'
      Horse.new(color, self, row, column)
    when 'R'
      Rook.new(color, self, row, column)
    when 'B'
      Bishop.new(color, self, row, column)
    end
  end

  private

  def edit_square(row, col, val)
    @grid[row][col] = val
  end

  def setup_board(fen) # setsup chess board according to fen
    place_piece(fen_to_arr(final_fen(fen)))
  end

  def final_fen(fen) # modifies fen so we can work with it
    final_arr = []
    fen.split('').each do |chr|
      if chr.to_i.to_s == chr
        final_arr.push(' ' * chr.to_i)
      else
        final_arr.push(chr)
      end
    end
    final_arr.join
  end

  def fen_to_arr(fen) # splits fen into 2d array so we can work with it
    arr = []
    fen.split('/').each { |wrd| arr.push(wrd.chars) }
    arr
  end

  def descide_color(sq) # helper function
    sq == sq.upcase ? 'W' : 'B'
  end

  def place_piece(arr) # places pieces on a chess board according to a 2d array
    arr.each_with_index do |row, r_i|
      row.each_with_index do |sq, c_i|
        next if DICT[sq] == ' '

        edit_square(r_i, c_i, DICT[sq].new(descide_color(sq), self, r_i, c_i))
      end
    end
  end
end
