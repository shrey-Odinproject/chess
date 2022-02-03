# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:cb) { described_class.new }
  describe '#square_occupied?' do
    context 'when square is occupied' do
      it 'return true' do
        cb.grid[0][7] = "\u2654"
        tst = cb.square_occupied?(0, 7)
        expect(tst).to be true
      end
    end

    context 'when square is unoccupied' do
      it 'return false' do
        cb.grid[0][7] = "\u2654"
        tst = cb.square_occupied?(0, 6)
        expect(tst).to be false
      end
    end
  end
end
