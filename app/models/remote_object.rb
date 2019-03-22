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

  def notify_change(cells, piece)
    @listeners["change"]&.each do |uid, callback|
      game = @games[uid]
      if game.sente == uid && piece.turn == :sente
        callback.call(cells)
      end

      if game.gote == uid && piece.turn == :gote
        callback.call(cells)
      end
    end
  end

  def request_new_game(from_uid, to_uid, block)
    @start_game_callback[from_uid] = block
    @listeners.dig("new_game", to_uid)&.call from_uid, to_uid
    nil
  end

  def start_game(uid, opposite_uid)
    game = Game.new(uid, opposite_uid) do |cells, piece|
      notify_change(cells, piece)
    end
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
