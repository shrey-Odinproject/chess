# frozen_string_literal: true

require_relative '../lib/move_manager'
require_relative '../lib/chess_board'
require_relative '../lib/player'
describe MoveManager do
  describe '#in_check?' do
    context 'when black king is under attack by white queen' do
      c_b = ChessBoard.new('rnb1k2r/ppp3pp/4Q3/8/3p4/2N5/PPP2PPP/R3KBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns true' do
        king = c_b.king('B')
        expect(mm.in_check?(king)).to be true
      end
    end

    context 'when white king is under attack by black bishop' do
      c_b = ChessBoard.new('rn2k2r/ppp3pp/8/8/2bp4/2N5/PPP1KPPP/R4BNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns true' do
        king = c_b.king('W')
        expect(mm.in_check?(king)).to be true
      end
    end

    context 'when white king is under attack by black pawn' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/2N5/PPPp1PPP/R3KBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns true' do
        king = c_b.king('W')
        expect(mm.in_check?(king)).to be true
      end
    end

    context 'when black king is not under attack by any white epiece' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/2N5/PPPp1PPP/R3KBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns false' do
        king = c_b.king('B')
        expect(mm.in_check?(king)).to be false
      end
    end
  end

  describe '#legal_move?' do
    context 'when moving a white piece such that the white king remains under check after move' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/2N5/PPPp1PPP/R3KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      piece = c_b.square(6, 0)
      it 'returns false' do
        expect(mm.legal_move?(plyr, piece, 4, 0)).to be false
      end
    end

    context 'when white piece captures the enemy piece checking the white king ' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      piece = c_b.square(7, 1)
      it 'returns true' do
        expect(mm.legal_move?(plyr, piece, 6, 3)).to be true
      end
    end

    context 'when white king captures the undefended enemy piece checking it' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      piece = c_b.square(7, 4)
      it 'returns true' do
        expect(mm.legal_move?(plyr, piece, 6, 3)).to be true
      end
    end

    context 'when moving the white king out of enemy piece\'s attacking path' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      piece = c_b.square(7, 4)
      it 'returns true' do
        expect(mm.legal_move?(plyr, piece, 7, 3)).to be true
      end
    end

    context 'when moving the white king out of 1 enemy piece\'s attacking path but moves into another\'s' do
      c_b = ChessBoard.new('rn2k2r/ppp3pp/8/8/2b5/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      piece = c_b.square(7, 4)
      it 'returns false' do
        expect(mm.legal_move?(plyr, piece, 6, 4)).to be false
      end
    end

    context 'when black king captures the white piece checking it but, white piece is protected' do
      c_b = ChessBoard.new('rn2k1br/pppB2pp/8/8/8/8/PPP2PPP/1N1RK1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      piece = c_b.square(0, 4)
      it 'returns false' do
        expect(mm.legal_move?(plyr, piece, 1, 3)).to be false
      end
    end

    context 'when blocking the attack path of white piece on black king with a black piece ' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/1B6/8/8/PPP2PPP/RN2K1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      piece = c_b.square(0, 1)
      it 'returns true' do
        expect(mm.legal_move?(plyr, piece, 1, 3)).to be true
      end
    end

    context 'when black piece captures the white piece checking the black king, and that white piece is protected' do
      c_b = ChessBoard.new('rn2k1br/pppQ2pp/2B5/8/8/8/PPP2PPP/RN2K1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      piece = c_b.square(0, 1)
      it 'returns true' do
        expect(mm.legal_move?(plyr, piece, 1, 3)).to be true
      end
    end
  end

  describe '#mated?' do
    context 'when black king is not in check and has nowhere safe to move and it is the only black piece' do
      c_b = ChessBoard.new('3R4/7R/4k3/R7/8/K7/8/5R2')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.mated?(plyr)).to be true
      end
    end

    context 'when black king in check and has nowhere safe to move and it is the only black piece' do
      c_b = ChessBoard.new('6k1/6Q1/8/8/K7/8/1B6/8')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.mated?(plyr)).to be true
      end
    end

    context 'when black king not in check and has nowhere safe to move and another piece is pinned defending the black king' do
      c_b = ChessBoard.new('BB6/8/8/8/8/K7/5Qn1/7k')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.mated?(plyr)).to be true
      end
    end

    context 'when black king in check and has nowhere safe to move and moving any other piece wont deal with check' do
      c_b = ChessBoard.new('R5k1/4Nppp/8/8/8/8/5K2/8')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.mated?(plyr)).to be true
      end
    end

    context 'when black king in check and has safe square to move' do
      c_b = ChessBoard.new('5k2/6Q1/8/8/K7/8/1B6/8')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns false' do
        expect(mm.mated?(plyr)).to be false
      end
    end

    context 'when black king not in check and has safe square to move' do
      c_b = ChessBoard.new('3k4/6Q1/8/8/K7/8/1B6/8')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns false' do
        expect(mm.mated?(plyr)).to be false
      end
    end

    context 'when black king not in check and has safe square to move but other black piece is pinned to king' do
      c_b = ChessBoard.new('3k4/4n3/5Q2/8/K7/8/1B6/8')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns false' do
        expect(mm.mated?(plyr)).to be false
      end
    end
  end

  # describe '#make_legal_move' do
  #   context 'when trying to move a piece that does not exist' do
  #     c_b = ChessBoard.new
  #     subject(:mm) { described_class.new(c_b) }
  #     plyr = Player.new('W')
  #     it 'produces appropriate error message' do
  #       expect(mm).to receive(:puts).with('this square is empty').once
  #       mm.make_legal_move(plyr, 4, 1, 2, 3)
  #     end
  #   end

  #   context 'when trying to move opponent\'s piece ' do
  #     c_b = ChessBoard.new
  #     subject(:mm) { described_class.new(c_b) }
  #     plyr = Player.new('W')
  #     it 'produces appropriate error message' do
  #       expect(mm).to receive(:puts).with('this is not ur piece').once
  #       mm.make_legal_move(plyr, 1, 4, 3, 4)
  #     end
  #   end

  #   context 'when trying to move a piece to a square it cannot go to ' do
  #     c_b = ChessBoard.new
  #     subject(:mm) { described_class.new(c_b) }
  #     plyr = Player.new('W')
  #     piece = c_b.square(6, 4)
  #     it 'produces appropriate error message' do
  #       expect(mm).to receive(:puts).with("#{piece} cant move there").once
  #       mm.make_legal_move(plyr, 6, 4, 2, 4)
  #     end
  #   end

  #   context 'when trying to move an illegal move' do
  #     c_b = ChessBoard.new('r2qkb1r/pp3ppp/n4n2/2p2b2/Q7/5P2/PP3PPP/RNB1KBNR')
  #     subject(:mm) { described_class.new(c_b) }
  #     plyr = Player.new('B')
  #     it 'produces appropriate error message' do
  #       expect(mm).to receive(:puts).with('illegal move').once
  #       mm.make_legal_move(plyr, 0, 5, 1, 4)
  #     end
  #   end

  #   context 'when making a legal move' do
  #     c_b = ChessBoard.new('r2qkb1r/pp3ppp/n4n2/2p2b2/Q7/5P2/PP3PPP/RNB1KBNR')
  #     subject(:mm) { described_class.new(c_b) }
  #     plyr = Player.new('B')
  #     it 'produces appropriate error message' do
  #       expect(plyr).to receive(:move_piece)
  #       mm.make_legal_move(plyr, 0, 3, 1, 3)
  #     end
  #   end
  # end
end
