# frozen_string_literal: true

require_relative '../lib/bishop'
require_relative '../lib/chess_board'
describe Bishop do
  describe '#valid_moves' do
    subject(:chess_bishop) { described_class.new('B', c_b, 3, 3) }
    context 'when bishop in centre of board with no obstacles' do
      let(:c_b) { ChessBoard.new('7k/8/8/3b4/8/8/8/K7') }
      it 'has 13 moves' do
        expect(chess_bishop.valid_moves.length).to eq(13)
      end
    end

    context 'when a friendly piece stands on 1 diagonal of bishop' do
      let(:c_b) { ChessBoard.new('7k/8/8/3b4/4p3/8/8/K7') }
      it 'no movement from and after the friendly piece in that direction' do
        expect(chess_bishop.valid_moves.length).to eq(9)
      end
    end

    context 'when bishop is surrounded by friendly pieces (all 4 diagonals)' do
      let(:c_b) { ChessBoard.new('7k/8/2q1n3/3b4/2q1q3/8/8/K7') }
      it 'no moves' do
        expect(chess_bishop.valid_moves.length).to eq(0)
      end
    end

    context 'when bishop is surrounded by friendly pieces (all 4 diagonals) with a gap of 1 square in each direction' do
      let(:c_b) { ChessBoard.new('7k/1q3r2/8/3b4/8/1r3p2/8/K7') }
      it '4 moves' do
        expect(chess_bishop.valid_moves.length).to eq(4)
      end
    end

    context 'when enemy blocks bishop in 1 diagonal' do
      let(:c_b) { ChessBoard.new('7k/8/8/3b4/4R3/8/8/K7') }
      it 'no movement after the enemy piece in that direction but capture availible' do
        expect(chess_bishop.valid_moves.length).to eq(10)
      end
    end

    context 'when bishop surrounded by enemy piece' do
      let(:c_b) { ChessBoard.new('7k/8/2N1B3/3b4/2R1Q3/8/8/K7') }
      it '4 capture moves' do
        expect(chess_bishop.valid_moves.length).to eq(4)
      end
    end
  end
end
