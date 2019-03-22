class Game
  attr_reader :sente, :gote

  def initialize(sente = nil, gote = nil, &on_change)
    @sente = sente
    @gote = gote
    @board = EightyOne::Board.new
    @board.initial_state
    @listener = on_change
  end

  def cells(reverse=nil)
    cells = @board.each_cells.map do |piece|
      piece && Piece.new(piece.face.symbol, piece.turn)
    end

    cells = cells.reverse if reverse
    cells
  end

  def dests_from(col, row)
    @board.dests_from(col, row)
  end

  def move(col, row, dest_col, dest_row)
    piece = @board.move_from(col, row).to(dest_col, dest_row)
    sells = self.cells
    @listener.call(cells, piece)
    cells
  end
end
