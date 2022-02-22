# frozen_string_literal: true

require_relative '../lib/horse'
require_relative '../lib/chess_board'
describe Horse do
  describe '#valid_moves' do
    subject(:chess_horse) { described_class.new('W', c_b, 3, 4) }
    context 'when horse at centre of board and horse\'s square empty' do
      let(:c_b) { ChessBoard.new('1k6/8/8/4N3/8/8/8/2K5') }

      it 'has 8 moves' do
        expect(chess_horse.valid_moves.length).to eq(8)
      end
    end

    context 'when horse at centre of board and enemy pieces on all of horse\'s square ' do
      let(:c_b) { ChessBoard.new('1k6/3q1p2/2r3p1/4N3/2b3n1/3n1r2/8/2K5') }

      it 'has 8 moves' do
        expect(chess_horse.valid_moves.length).to eq(8)
      end
    end

    context 'when horse at centre of board and friendly pieces on all of horse\'s square ' do
      let(:c_b) { ChessBoard.new('1k6/3P1B2/2Q3P1/4N3/2R3P1/3K1N2/8/8') }

      it 'has 0 moves' do
        expect(chess_horse.valid_moves.length).to eq(0)
      end
    end

    context 'on start position' do
      subject(:chess_horse) { described_class.new('W', c_b, 7, 1) }
      let(:c_b) { ChessBoard.new }

      it 'has 2 moves' do
        expect(chess_horse.valid_moves.length).to eq(2)
      end
    end
  end
end
