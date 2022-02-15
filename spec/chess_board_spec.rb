# frozen_string_literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:cb) { described_class.new }

  describe '#occupied_square?' do
    context 'when square is occupied' do
      it 'return true' do
        tst = cb.occupied_square?(0, 7) # a rondom occupied square
        expect(tst).to be true
      end
    end

    context 'when square is unoccupied' do
      it 'return false' do
        tst = cb.occupied_square?(3, 6) # random middle board square
        expect(tst).to be false
      end
    end
  end

  describe '#on_board?' do
    context 'when coordinates are present on board' do
      it 'return true' do
        tst = cb.on_board?(0, 7) # a rondom square on board
        expect(tst).to be true
      end
    end

    context 'when coordinates are outside board' do
      it 'return false' do
        tst = cb.on_board?(10, 61) # such a square doesnot exist
        expect(tst).to be false
      end
    end
  end

  describe '#piece_movement' do
    let(:piece) { double('chess_piece', row: 7, column: 4) }
    context 'when moving a chess piece on board to destination square' do
      it 'edits the board to display piece movement' do
        r_f = 0
        c_f = 0
        cb.piece_movement(piece, r_f, c_f)
        expect(cb.square(piece.row, piece.column)).to eq(' ')
        expect(cb.square(r_f, c_f)).to eq(piece)
      end
    end
  end
end
