class Game
  attr_reader :sente, :gote

  def initialize(sente = nil, gote = nil)
    @sente = sente
    @gote = gote
    @board = EightyOne::Board.new
    @board.initial_state
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
    @board.move_from(col, row).to(dest_col, dest_row)
    cells
  end
end
