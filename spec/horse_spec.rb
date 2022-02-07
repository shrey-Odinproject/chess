# frozen_string_literal: true

require_relative '../lib/horse'

describe Horse do
  let(:c_b) { double('chess_board', show: nil) }
  subject(:horsey) { described_class.new('B', c_b, 0, 1) }

  describe '#move' do
    context 'when moving to a valid square' do
      before do
        allow(horsey).to receive(:valid_moves).and_return [[2, 2], [2, 0]]
      end
      it 'moves the piece on board and updates the position' do
        to_row = 2
        to_column = 2 # 2,2 is present in array returned by valid_moves
        expect(c_b).to receive(:move_piece_on_board).with(horsey, to_row, to_column).and_return(horsey)
        expect(c_b).to receive(:show)
        horsey.move(to_row, to_column)
      end
    end

    context 'when moving to an invalid square' do
      before do
        allow(horsey).to receive(:valid_moves).and_return [[2, 2], [2, 0]]
      end
      it 'displays error msg' do
        to_row = 2
        to_column = 5 # 2,5 is not in array returned by valid_moves
        expect(c_b).not_to receive(:move_piece_on_board).with(horsey, to_row, to_column)
        expect(c_b).not_to receive(:show)
        expect(horsey).to receive(:puts).with("#{subject.class} cant move there")
        horsey.move(to_row, to_column)
      end
    end
  end
end
