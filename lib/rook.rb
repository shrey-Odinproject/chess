# frozen_string_literal: true

# a chess rook
class Rook
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265c" : "\u2656"
  end
end
