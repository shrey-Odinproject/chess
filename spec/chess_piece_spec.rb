# frozen_string_literal: true

require_relative '../lib/chess_piece'

describe ChessPiece do
  let(:c_b) { double('chess_board', show: nil) }
  subject(:chess_piece) { described_class.new('B', c_b, 0, 1) }

  describe '#move' do
    before do
      allow(chess_piece).to receive(:valid_moves).and_return [[2, 3], [7, 0]]
    end

    context 'when moving to a valid square' do
      it 'moves the piece on board and updates the position' do
        to_row = 7
        to_column = 0 # 7,0 is present in array returned by valid_moves
        expect(c_b).to receive(:show_piece_movement).with(chess_piece, to_row, to_column).and_return(chess_piece)
        expect(c_b).to receive(:show)
        chess_piece.move(to_row, to_column)
      end
    end

    context 'when moving to an invalid square' do
      it 'displays error msg' do
        to_row = 2
        to_column = 5 # 2,5 is not in array returned by valid_moves
        expect(c_b).not_to receive(:show_piece_movement).with(chess_piece, to_row, to_column)
        expect(c_b).not_to receive(:show)
        expect(chess_piece).to receive(:puts).with("#{subject.class} cant move there")
        chess_piece.move(to_row, to_column)
      end
    end
  end
end
