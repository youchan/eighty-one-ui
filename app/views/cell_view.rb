class CellView
  include Hyalite::Component

  def render
    cell = @props[:cell]
    side = cell && cell.turn == "sente" ? "self" : "opposite"
    addition = @props[:selected] ? " selected" : ""
    addition += @props[:movable] ? " movable" : ""
    div({class: "cell#{addition}", onClick: @props[:onClick]}) do
      if cell
        img(class: "piece #{side}", src: "assets/images/piece_#{cell.face}.png")
      end
    end
  end
end
