# frozen_string_literal: true

# a chess pawn
class Pawn
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265f" : "\u2659"
  end
end
