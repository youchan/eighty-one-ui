class Piece
  attr_reader :face, :turn

  def initialize(face, turn)
    @face = face
    @turn = turn
  end
end
