# frozen_string_literal: true

# a chess horse
class Horse
  attr_reader :color, :chess_board
  attr_accessor :row, :column

  def initialize(col, chess_board, row, column)
    @color = col
    @chess_board = chess_board
    @row = row
    @column = column
  end

  def to_s
    color == 'W' ? "\u265e" : "\u2658"
  end

  def move(to_row, to_column)
    if valid_moves.include?([to_row, to_column])
      chess_board.move_piece_on_board(self, to_row, to_column)
      update_position(to_row, to_column)
      chess_board.show
    else
      puts "#{self.class} cant move there"
    end
  end

  private

  def possible_moves
    # all the moves that are on board (despite square being occupied by horse's teammate)
    n1 = [row + 1, column + 2] if chess_board.on_board?(row + 1, column + 2)
    n2 = [row + 1, column - 2] if chess_board.on_board?(row + 1, column - 2)
    n3 = [row - 1, column + 2] if chess_board.on_board?(row - 1, column + 2)
    n4 = [row - 1, column - 2] if chess_board.on_board?(row - 1, column - 2)

    n5 = [row + 2, column + 1] if chess_board.on_board?(row + 2, column + 1)
    n6 = [row + 2, column - 1] if chess_board.on_board?(row + 2, column - 1)
    n7 = [row - 2, column + 1] if chess_board.on_board?(row - 2, column + 1)
    n8 = [row - 2, column - 1] if chess_board.on_board?(row - 2, column - 1)

    [n1, n2, n3, n4, n5, n6, n7, n8] - [nil]
  end

  def valid_moves
    # return array of cordinates that are not occupied by hors's teammates
    valid = []
    possible_moves.each do |r, c|
      if !chess_board.occupied_square?(r, c)
        valid.push([r, c])
      elsif chess_board.grid[r][c].color != color
        valid.push([r, c])
      end
    end
    p valid
  end

  def update_position(row_up, col_up)
    self.row = row_up
    self.column = col_up
  end
end
