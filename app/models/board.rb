class Board
  def initialize
    pos = (1..9).map{|i| [7, 10 - i]} + [[8,8], [8,2]] + (1..9).map{|i| [9, 10 - i]}
    @cells = Array.new(81)
    pos.each {|(row, col)| self[row, col] = Piece.new(row, col) }
  end

  def [](row, col)
    @cells[(9 - row) * 9 + col - 1]
  end

  def []=(row, col, piece)
    i = (9 - row) * 9 + col - 1
    @cells[(9 - row) * 9 + col - 1] = piece
  end
end
