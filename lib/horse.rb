# frozen_string_literal: true

# a chess horse
class Horse
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265e" : "\u2658"
  end
end
