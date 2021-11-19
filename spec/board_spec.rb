describe Board do
  describe '#take_piece' do
    #board.take_piece(piece_pos, destination_pos)
    #Command method, test that piece take destination piece's square
    context 'when there\'s a piece on both squares' do
      board = {:a1: 'knight', :a2: 'rook'}
      subject(:board_take) { described_class.new(board) }

      it 'moves piece to destination and replaces it with nil' do
        board_take.setup

      end
    end
  end
end