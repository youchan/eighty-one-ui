require "hyalite"
require "menilite"
require "opal/drb"
require_relative "models/account"
require_relative "models/session"
require_relative "models/piece"
require_relative "controllers/application_controller"
require_relative "views/player_pane"
require_relative "views/cell_view"
require_relative "views/board_view"
require_relative "views/lobby_view"

class AppView
  include Hyalite::Component

  state :game, nil
  state :account, nil
  state :login_accounts, []
  state :request_join, nil

  before_mount do
    @remote = DRb::DRbObject.new_with_uri "ws://127.0.0.1:8002"
    DRb.start_service("ws://127.0.0.1:8002/callback")

    ApplicationController.my_account do |_, res|
      account = Account.new(res["model"]["fields"])
      @remote.notify_login(account)

      @remote.on(:login, account.uid) do
        update_login_accounts(account)
      end

      @remote.on(:new_game, account.uid) do |from_uid, to_uid|
        if account.uid == to_uid
          @remote.start_game(account.uid, from_uid).then do |game|
            set_state(game: game)
          end
        end
      end

      update_login_accounts(account)
    end
  end

  def update_login_accounts(account)
    Session.fetch!(filter: {login: true}, includes: :account) do |sessions|
      begin
        set_state(account: account, login_accounts: sessions.map(&:account).reject{|a| a.uid == account.uid})
      rescue => e
        puts e.backtrace.join("\n")
      end
    end
  end

  def request_new_game(uid)
    account = @state[:account]
    callback = Proc.new do |game|
      puts ">>>>>>>>>> callback #{game}"
      set_state(game: game)
    end
    @remote.request_new_game(account.uid, uid, callback)
  end

  def render
    game = @state[:game]
    account = @state[:account]
    start_game = self.method(:request_new_game)
    login_accounts = @state[:login_accounts]

    div(class: "main") do
      if account
        if game
          PlayerPane.el(class: "player oppsite", name: "John", side: "opposite")
          BoardView.el(game: game)
          PlayerPane.el(class: "player self", name: "youchan", side: "self")
        else
          LobbyView.el(account: account, login_accounts: login_accounts, on_start: start_game)
        end
      end
    end
  end
end
Hyalite.render(Hyalite.create_element(AppView), $document[".content"])
