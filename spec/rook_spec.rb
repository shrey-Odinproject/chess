# frozen_string_literal: true

require_relative '../lib/rook'
require_relative '../lib/chess_board'

describe Rook do
  describe '#valid_moves' do
    subject(:chess_rook) { described_class.new('W', c_b, 4, 4) }
    context 'when rook in centre of board and no obstacles' do
      let(:c_b) { ChessBoard.new('2k5/8/8/8/4R3/8/8/1K6') }
      it 'has 14 moves' do
        expect(chess_rook.valid_moves.length).to eq(14)
      end
    end

    context 'when a friendly piece stands to side of rook' do
      let(:c_b) { ChessBoard.new('2k5/8/8/8/4RN2/8/8/1K6') }
      it 'no movement from and after the friendly piece in that direction' do
        expect(chess_rook.valid_moves.length).to eq(11)
      end
    end

    context 'when rook is surrounded by friendly piecs in all 4 direction' do
      let(:c_b) { ChessBoard.new('2k5/8/8/4Q3/3BRN2/4P3/8/1K6') }
      it 'no moves' do
        expect(chess_rook.valid_moves.length).to eq(0)
      end
    end

    context 'when rook is surrounded by friendly piecs in all 4 direction but are 1 square away from rook in 4 directions' do
      let(:c_b) { ChessBoard.new('2k5/8/4Q3/8/2B1R1N1/8/4P3/1K6') }
      it '4 moves are valid' do
        expect(chess_rook.valid_moves.length).to eq(4)
      end
    end

    context 'when enemy piece blocks rook in 1 direction' do
      let(:c_b) { ChessBoard.new('2k5/8/8/8/4Rb2/8/8/1K6') }
      it 'no movement after the enemy piece in that direction but capture availible' do
        expect(chess_rook.valid_moves.length).to eq(12)
      end
    end

    context 'when rook is surrounded by enemy piecs in all 4 direction' do
      let(:c_b) { ChessBoard.new('2k5/8/8/4q3/3bRn2/4p3/8/1K6') }
      it '4 capture moves' do
        expect(chess_rook.valid_moves.length).to eq(4)
      end
    end
  end
end
