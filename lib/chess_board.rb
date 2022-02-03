# frozen_string_literal: true

class ChessBoard
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def show(boxlen = 3)
    puts '  0   1   2   3   4   5   6   7'
    # Define box drawing characters
    side = '│'
    topbot = '─'
    tl = '┌'
    tr = '┐'
    bl = '└'
    br = '┘'
    lc = '├'
    rc = '┤'
    tc = '┬'
    bc = '┴'
    crs = '┼'
    ##############################
    draw = []
    grid.each_with_index do |row, rowindex|
      # TOP OF ROW Upper borders
      row.each_with_index do |col, colindex|
        if rowindex == 0
          colindex == 0 ? start = tl : start = tc
          draw << start + (topbot * boxlen)
          colindex == row.length - 1 ? draw << tr : ""
        end
      end
      draw << "\n" if rowindex == 0

      # MIDDLE OF ROW: DATA
      row.each do |col|
        draw << side + col.to_s.center(boxlen)
      end
      draw << side + "\n"

      # END OF ROW
      row.each_with_index do |col, colindex|
        if colindex == 0
          rowindex == grid.length - 1 ? draw << bl : draw << lc
          draw << (topbot * boxlen)
        else
          rowindex == grid.length - 1 ? draw << bc : draw << crs
          draw << (topbot * boxlen)
        end
        endchar = rowindex == grid.length - 1 ? br : rc

        # Overhang elimination if the next row is shorter
        if grid[rowindex + 1]
          if grid[rowindex + 1].length < grid[rowindex].length
            endchar = br
          end
        end
        colindex == row.length - 1 ? draw << endchar : ""
      end
      draw << "\n"
    end

    draw.each do |char|
      print char
    end
    nil # function breaks without this return
  end

  def square_occupied?(row, col)
    grid[row][col] == nil ? false : true
  end
end
