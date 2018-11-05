class RemoteObject
  def initialize
    @listeners = {}
    @start_game_callback = {}
    @games = {}
  end

  def check_in(uid)
    DRbObject.new(@games[uid])
  end

  def notify_login(account)
    @listeners["login"]&.each do |uid, callback|
      callback.call
    end
    nil
  end

  def request_new_game(from_uid, to_uid, block)
    @start_game_callback[from_uid] = block
    @listeners.dig("new_game", to_uid)&.call from_uid, to_uid
    nil
  end

  def start_game(uid, opposite_uid)
    game = Game.new(uid, opposite_uid)
    @games[uid] = game
    @games[opposite_uid] = game
    @start_game_callback[opposite_uid].call(DRbObject.new(game))
    DRbObject.new(game)
  end

  def on(label, uid, &callback)
    (@listeners[label.to_s] ||= {})[uid] = callback
    nil
  end
end
