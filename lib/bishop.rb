# frozen_string_literal: true

# a chess bishop
class Bishop
  attr_reader :color

  def initialize(col)
    @color = col
  end

  def to_s
    color == 'W' ? "\u265d" : "\u2657"
  end
end
