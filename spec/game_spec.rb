# frozen_string_literal: true

require_relative '../lib/game'
describe Game do
  let(:game) { described_class.new }
  let(:pl) { double('player', color: 'W') }
  describe '#valid_move_input' do
    context 'when entering a valid input' do
      it 'returns the input' do
        ginp = 'e4b5'
        allow(game).to receive(:ask_move_input).with(pl).and_return(ginp)
        expect(game.valid_move_input(pl)).to eq(ginp)
      end
    end
    context 'when entering an invalid format and then a valid input' do
      before do
        inp = 'random'
        ginp = 'e4b5'
        allow(game).to receive(:ask_move_input).with(pl).and_return(inp, ginp)
      end
      it 'displays error msg once' do
        expect(game).to receive(:puts).with('invalid form of input').once
        game.valid_move_input(pl)
      end
    end
  end

  describe '#determine_move_type' do
    context 'when piece doesnot exist' do
      it "returns 'this square is empty'" do
        fr, fc, tr, tc = 3, 0, 4, 0
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'this square is empty'
      end
    end

    context 'when trying to move opponent\'s piece' do
      it "returns false 'this is not ur piece'" do
        fr, fc, tr, tc = 1, 0, 2, 0
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'this is not ur piece'
      end
    end

    context 'when trying to castle but cannot' do
      it "returns 'can\'t castle'" do
        fr, fc, tr, tc = 7, 4, 7, 7
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'can\'t castle'
      end
    end

    context 'when trying to castle and can' do
      let(:game) { described_class.new(ChessBoard.new('r3kbnr/ppppp1pp/5p2/8/4P3/8/PPPP1PPP/R3K2R')) }
      it 'returns the king,rook and castle-type' do
        fr, fc, tr, tc = 7, 4, 7, 7
        king = game.chess_board.square(fr, fc)
        rook = game.chess_board.square(tr, tc)
        expect(game.determine_move_type(fr, fc, tr, tc)).to eq [king, rook, 'short']
      end
    end

    context 'when trying to en_passant left when it cannot' do
      it "returns 'can\'t en_passant left'" do
        fr, fc, tr, tc = 6, 4, 5, 3
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'can\'t en_passant left'
      end
    end

    context 'when trying to en_passant right when it cannot' do
      it "returns 'can\'t en_passant right'" do
        fr, fc, tr, tc = 6, 4, 5, 5
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'can\'t en_passant right'
      end
    end

    context 'when making an en passant' do
      let(:game) { described_class.new(ChessBoard.new('r3kbnr/ppp1pppp/8/3pP3/8/3P4/PPP2PPP/R3K2R')) }
      it 'returns the pawn' do
        fr, fc, tr, tc = 3, 4, 2, 3
        allow(game.move_manager).to receive(:can_en_passant_left?).and_return(true)
        piece = game.chess_board.square(fr, fc)
        expect(game.determine_move_type(fr, fc, tr, tc)).to eq([piece])
      end
    end

    context 'when making a normal move but piece cannot move to destination' do
      it 'returns false' do
        fr, fc, tr, tc = 7, 1, 7, 0
        # piece = game.chess_board.square(fr, fc)
        expect(game.determine_move_type(fr, fc, tr, tc)).to eq(false)
      end
    end

    context 'when making an illegal move' do
      let(:game) { described_class.new(ChessBoard.new('r3k1nr/ppppp1pp/5p2/8/3PP3/2b5/PPP2PPP/R3K2R')) }
      it "returns 'illegal move'" do
        fr, fc, tr, tc = 7, 0, 7, 3
        expect(game.determine_move_type(fr, fc, tr, tc)).to be 'illegal move'
      end
    end

    context 'making a normal valid legal move' do
      it 'returns the piece and its destination' do
        fr, fc, tr, tc = 6, 4, 4, 4
        piece = game.chess_board.square(fr, fc)
        expect(game.determine_move_type(fr, fc, tr, tc)).to eq([piece, tr, tc])
      end
    end
  end
end
