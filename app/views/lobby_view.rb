class LobbyView
  include Hyalite::Component

  def handle_start
    target = @refs[:opposite].children.find{|el| el[:selected]}
    @props[:on_start].call target.value
  end

  def render
    handle_start = method(:handle_start)
    login_accounts = @props[:login_accounts]
    request_join = @props[:request_join]

    section(class: "hero is-fullheight") do
      div(class: "hero-body") do
        div(class: "container") do
          div(class: "box") do
            h3(nil, "Lobby")
            if request_join
              div(nil, reuest_join.from)
            end
            if login_accounts && login_accounts.length > 0
              div(class: :field) do
                div({class: "label"}, "Select a opposite player")
                div({class: "select"}) do
                  select({ref: "opposite"}) do
                    login_accounts.each do |account|
                      option({value: account.uid}, account.name)
                    end
                  end
                end
              end
              div(class: :field) do
                div({class: 'control'},
                  button({class: 'button is-primary', onClick: handle_start}, "Invite game")
                )
              end
            else
              div(nil, div(nil, "Nobody logged-in"))
            end
          end
        end
      end
    end
  end
end
