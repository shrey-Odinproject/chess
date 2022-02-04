# frozen_string_literal: true

# a chess pawn
class Pawn
  attr_reader :symbol, :color

  def initialize(col = nil)
    @symbol = colored_symbol
    @color = col
  end

  def colored_symbol
    color == 'B' ? "\u2659" : "\u265f"
  end
end
