require_relative '../lib/board'

describe Board do
  describe '#move_piece' do
    #board.move_piece(piece_pos, destination_pos)
    #Command method, test that piece takes destination piece's square and is replaced with nil
    context 'when there\'s a piece on both squares' do
      board = {a1: 'knight', a2: 'rook'}
      subject(:board_move) { described_class.new(board) }

      it 'moves piece to destination and replaces it with nil' do
        expected_board = {
          a1: nil,
          a2: 'knight'
        }
        board_move.move_piece(:a1, :a2)
        expect(board_move.board).to eq(expected_board)
      end
    end
  end
end