# frozen_string_literal: true

require_relative '../lib/king'
require_relative '../lib/chess_board'
describe King do
  describe '#valid_moves' do
    subject(:chess_king) { described_class.new('W', c_b, 4, 3) }
    context 'when king in centre of board with no obstacles' do
      let(:c_b) { ChessBoard.new('7k/8/8/8/3K4/8/8/8') }
      it 'has 8 moves' do
        expect(chess_king.valid_moves.length).to eq(8)
      end
    end

    context 'when a friendly piece stands one of king\'s adjacent square' do
      let(:c_b) { ChessBoard.new('7k/8/8/8/3KB3/8/8/8') }
      it 'no movement to square occupied by friendly piece' do
        expect(chess_king.valid_moves.length).to eq(7)
      end
    end

    context 'when king is surrounded by friendly pieces in all direction' do
      let(:c_b) { ChessBoard.new('7k/8/8/2BQR3/2NKB3/2PPN3/8/8') }
      it 'no moves' do
        expect(chess_king.valid_moves.length).to eq(0)
      end
    end

    context 'when king is surrounded by friendly pieces in all direction but with gap of 1 aquare' do
      let(:c_b) { ChessBoard.new('7k/8/1B1Q1R2/8/1N1K1B2/8/1P1P1N2/8') }
      it 'has all its moves' do
        expect(chess_king.valid_moves.length).to eq(8)
      end
    end

    context 'when enemy piece blocks king\'s single square' do
      let(:c_b) { ChessBoard.new('7k/8/8/3n4/3K4/8/8/8') }
      it 'has all its moves cause of capture' do
        expect(chess_king.valid_moves.length).to eq(8)
      end
    end

    context 'when enemy pieces blocks all of king\'s square' do
      let(:c_b) { ChessBoard.new('7k/8/8/2qnb3/2pKn3/2ppr3/8/8') }
      it 'has all its moves cause of captures' do
        expect(chess_king.valid_moves.length).to eq(8)
      end
    end
  end
end
