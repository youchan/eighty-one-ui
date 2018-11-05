class PlayerPane
  include Hyalite::Component

  def render
    side = @props[:side]
    name = @props[:name]
    div(class: "player #{side}") do
      if side == "self"
        div({class: "player-icon"}, img(src: "assets/images/icon.png"))
      end
      div({class: "name-field"}, div({class: "name"}, name))
      if side == "opposite"
        div({class: "player-icon"}, img(src: "assets/images/icon.png"))
      end
    end
  end
end
