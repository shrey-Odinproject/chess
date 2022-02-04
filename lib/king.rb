# frozen_string_literal: true

# a chess king
class King
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265A" : "\u2654"
  end
end
