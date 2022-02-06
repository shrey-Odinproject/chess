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

  def move(row_final, column_final)
    if valid_moves.include?([row_final, column_final])
      chess_board.grid[row][column] = ' '
      chess_board.grid[row_final][column_final] = self
      self.row = row_final
      self.column = column_final
      chess_board.show
    else
      puts 'horse cant jump there'
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
      if !chess_board.square_occupied?(r, c)
        valid.push([r, c])
      elsif chess_board.grid[r][c].color != color
        valid.push([r, c])
      end
    end
    p valid
  end
end
