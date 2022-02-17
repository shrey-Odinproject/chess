# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/chess_board'
describe Pawn do
  describe '#valid_moves' do
    subject(:chess_pawn) { described_class.new('W', c_b, 6, 3) }

    context 'when white pawn on home square and front 2 squares are empty' do
      let(:c_b) { ChessBoard.new('8/8/8/8/8/8/3P4/8') }

      it 'has 2 moves (push, 2step)' do
        expect(chess_pawn.valid_moves.length).to eq(2)
      end
    end

    context 'when white pawn on home square and a piece is present on 2 ranks ahead' do
      let(:c_b) { ChessBoard.new('8/8/8/8/3q4/8/3P4/8') }

      it 'has 1 move (push)' do
        expect(chess_pawn.valid_moves.length).to eq(1)
      end
    end

    context 'when white pawn on home square and has a piece in front of it' do
      let(:c_b) { ChessBoard.new('8/8/8/8/3q4/3B4/3P4/8') }

      it 'has no moves' do
        expect(chess_pawn.valid_moves.length).to eq 0
      end
    end

    context 'when white pawn on home square and an enemy piece is on capture square' do
      let(:c_b) { ChessBoard.new('8/8/8/8/8/4r3/3P4/8') }

      it 'has 3 moves (push, 2 step, capture' do
        expect(chess_pawn.valid_moves.length).to eq 3
      end
    end

    context 'when white pawn on home square and 2 enemy pieces are on both capture squares' do
      let(:c_b) { ChessBoard.new('8/8/8/8/8/2b1r3/3P4/8') }

      it 'has 4 moves (push, 2 step, 2 captures' do
        expect(chess_pawn.valid_moves.length).to eq 4
      end
    end

    context 'when white pawn not on home square and nothing to capture' do
      let(:c_b) { ChessBoard.new('8/8/8/8/3P4/8/8/8') }
      subject(:chess_pawn) { described_class.new('W', c_b, 4, 3) }
      it 'has 1 move (push)' do
        expect(chess_pawn.valid_moves.length).to eq 1
      end
    end

    context 'when white pawn reach end of board' do
      let(:c_b) { ChessBoard.new('3P4/8/8/8/8/8/8/8') }
      subject(:chess_pawn) { described_class.new('W', c_b, 0, 3) }
      it 'has no move' do
        expect(chess_pawn.valid_moves.length).to eq 0
      end
    end
  end
end
