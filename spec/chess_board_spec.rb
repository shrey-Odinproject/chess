# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:cb) { described_class.new }

  describe '#square_occupied?' do
    context 'when square is occupied' do
      it 'return true' do
        tst = cb.square_occupied?(0, 7) # a rondom occupied square
        expect(tst).to be true
      end
    end

    context 'when square is unoccupied' do
      it 'return false' do
        tst = cb.square_occupied?(3, 6) # random middle board square
        expect(tst).to be false
      end
    end
  end
end
