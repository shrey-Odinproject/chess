# frozen_string_literal: true

require_relative '../lib/chess_board'
# require_relative '../lib/pawn'

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

  describe '#setup_pawns' do
    context 'places white and black pawns on 7th and 2nd ranks' do
      it 'deploys correct colored pawns' do
        cb.setup_pawns
        tst1 = cb.grid[1].all? { |square| square.color == 'B' }
        tst2 = cb.grid[6].all? { |square| square.color == 'W' }
        expect(tst1).to be true
        expect(tst2).to be true
      end
    end
  end
end
