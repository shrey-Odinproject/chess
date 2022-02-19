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
      it 'returns false' do
        expect(mm.legal_move?(plyr, 6, 0, 4, 0)).to be false
      end
    end

    context 'when white piece captures the enemy piece checking the white king ' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      it 'returns true' do
        expect(mm.legal_move?(plyr, 7, 1, 6, 3)).to be true
      end
    end

    context 'when white king captures the undefended enemy piece checking it' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      it 'returns true' do
        expect(mm.legal_move?(plyr, 7, 4, 6, 3)).to be true
      end
    end

    context 'when moving the white king out of enemy piece\'s attacking path' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/8/8/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      it 'returns true' do
        expect(mm.legal_move?(plyr, 7, 4, 7, 3)).to be true
      end
    end

    context 'when moving the white king out of 1 enemy piece\'s attacking path but moves into another\'s' do
      c_b = ChessBoard.new('rn2k2r/ppp3pp/8/8/2b5/8/PPPp1PPP/RN2KBNR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('W')
      it 'returns false' do
        expect(mm.legal_move?(plyr, 7, 4, 6, 4)).to be false
      end
    end

    context 'when black king captures the white piece checking it but, white piece is protected' do
      c_b = ChessBoard.new('rn2k1br/pppB2pp/8/8/8/8/PPP2PPP/1N1RK1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns false' do
        expect(mm.legal_move?(plyr, 0, 4, 1, 3)).to be false
      end
    end

    context 'when blocking the attack path of white piece on black king with a black piece ' do
      c_b = ChessBoard.new('rn2k1br/ppp3pp/8/1B6/8/8/PPP2PPP/RN2K1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.legal_move?(plyr, 0, 1, 1, 3)).to be true
      end
    end

    context 'when black piece captures the white piece checking the black king, and that white piece is protected' do
      c_b = ChessBoard.new('rn2k1br/pppQ2pp/2B5/8/8/8/PPP2PPP/RN2K1NR')
      subject(:mm) { described_class.new(c_b) }
      plyr = Player.new('B')
      it 'returns true' do
        expect(mm.legal_move?(plyr, 0, 1, 1, 3)).to be true
      end
    end
  end
end
