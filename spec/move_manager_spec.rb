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

  describe '#make_move' do
    context 'when moving a piece' do
      chessboard = ChessBoard.new('rnbqkbnr/ppppppPp/8/8/8/8/PPPPP1PP/RNBQKBNR')
      subject(:m_m) { described_class.new(chessboard) }
      pl = Player.new('W')
      it 'sends player the appropriate message' do
        piece = chessboard.square(7, 1)
        expect(pl).to receive(:move_piece).with(piece, 5, 2)
        m_m.make_move(pl, piece, 5, 2)
      end
    end

    context 'when moving pawn to promotion square ' do
      chessboard = ChessBoard.new('rnbqkbnr/ppppppPp/8/8/8/8/PPPPP1PP/RNBQKBNR')
      subject(:m_m) { described_class.new(chessboard) }
      let(:prom_piece) { double('Q/H/R/B', color: 'W', chess_board: chessboard, row: 0, column: 7) }
      pl = Player.new('W')
      before do
        allow(chessboard).to receive(:make_promotion_piece).and_return(prom_piece)
      end
      it 'pawn becomes new piece' do
        piece = chessboard.square(1, 6)
        # expect(pl).to receive(:move_piece).with(piece, 0, 7)
        m_m.make_move(pl, piece, 0, 7)
        expect(chessboard.square(0, 7)).to eq(prom_piece)
      end
    end
  end

  describe '#can_castle_short?' do
    context 'when king and rook on different ranks' do
      c_b = ChessBoard.new('rnbqkbnr/pppppppp/8/8/6P1/3NB3/PPPPK2P/RNBQ3R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(6, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end
    context 'when king has moved' do
      c_b = ChessBoard.new('r3k2r/pppppp1P/2b2n2/3nb3/2B1Q3/2N5/PP1B2PP/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      before do
        king = c_b.square(7, 4)
        mm.make_move(player, king, 7, 3)
      end
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 3)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when rook has moved' do
      c_b = ChessBoard.new('r3k2r/pppppp1P/2b2n2/3nb3/2B1Q3/2N5/PP1B2PP/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      before do
        rook = c_b.square(7, 7)
        mm.make_move(player, rook, 7, 6)
      end
      it 'returns false' do
        rook = c_b.square(7, 6)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when king in check' do
      c_b = ChessBoard.new('r3k3/pppppp1P/2b2n2/3nb3/2B1r3/2N5/PP1B2PP/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when any piece present between king and rook' do
      c_b = ChessBoard.new('r3k3/pppppp1P/2b2n2/1r1nb3/2B5/8/PP1B2PP/R3K1NR')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when any square in short castle path under attack' do
      c_b = ChessBoard.new('r3k3/pppppp1P/2b2n2/1r1n4/2B2N2/3b4/PP1B2PP/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when king in check after castle' do
      c_b = ChessBoard.new('r3k3/pppbp2P/2b2n2/1r1n4/2B2N2/8/PP1B2Pp/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns false' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be false
      end
    end

    context 'when short castling conditions are met' do
      c_b = ChessBoard.new('r3k3/pppbp3/2b2n2/1r1n4/5N2/8/PP1B1BPP/R3K2R')
      subject(:mm) { described_class.new(c_b) }
      player = Player.new('W')
      it 'returns true' do
        rook = c_b.square(7, 7)
        king = c_b.square(7, 4)
        expect(mm.can_castle_short?(player, king, rook)).to be true
      end
    end
  end

  describe '#can_en_passant_left?' do
    context 'when pawn is not on \'passant\' rank' do
      c_b = ChessBoard.new('rnbqkbnr/pp1ppppp/8/2p5/3P4/8/PPP1PPPP/RNBQKBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns false' do
        pawn = c_b.square(4, 3)
        last_move = [c_b.square(3, 2), 3, 2, 1]
        expect(mm.can_en_passant_left?(pawn, last_move)).to be false
      end
    end

    context 'when last move wasn\'t a pawn double step' do
      c_b = ChessBoard.new('rnbqkbnr/pp1ppppp/8/2pP4/8/8/PPP1PPPP/RNBQKBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns false' do
        pawn = c_b.square(3, 3)
        last_move = [c_b.square(3, 2), 3, 2, 2]
        expect(mm.can_en_passant_left?(pawn, last_move)).to be false
      end
    end

    context 'when no enemy pawn on adjacent left' do
      c_b = ChessBoard.new('rnbqkbnr/p1pppppp/8/1p1P4/8/8/PPP1PPPP/RNBQKBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns false' do
        pawn = c_b.square(3, 3)
        last_move = [c_b.square(3, 1), 3, 1, 1]
        expect(mm.can_en_passant_left?(pawn, last_move)).to be false
      end
    end

    context 'when enemy pawn does a double step and lands just on left of our pawn' do
      c_b = ChessBoard.new('rnbqkbnr/pp1ppppp/8/2pP4/8/8/PPP1PPPP/RNBQKBNR')
      subject(:mm) { described_class.new(c_b) }
      it 'returns true' do
        pawn = c_b.square(3, 3)
        last_move = [c_b.square(3, 2), 3, 2, 1]
        expect(mm.can_en_passant_left?(pawn, last_move)).to be true
      end
    end
  end
end
