# frozen_string_literal: true

# a chess queen
class Queen
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265b" : "\u2655"
  end
end
