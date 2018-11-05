require 'bundler/setup'
Bundler.require(:default)

require 'menilite'
require 'sinatra/activerecord'
require "eighty_one"

require_relative 'server'
Dir[File.expand_path('../app/models/', __FILE__) + '/**/*.rb'].each {|file| require(file) }
Dir[File.expand_path('../app/controllers/', __FILE__) + '/**/*.rb'].each {|file| require(file) }

$DEBUG=true

app = Rack::Builder.app do
  server = Server.new(host: 'localhost')

  map '/' do
    #use DRb::WebSocket::RackApp
    run server
  end

  map '/assets' do
    run server.settings.opal.sprockets
  end

  map '/api' do
    router = Menilite::Router.new
    run router.routes(server.settings)
  end
end

DRb::WebSocket::RackApp.config.use_rack = true

DRb.start_service("ws://127.0.0.1:8002", RemoteObject.new)

thin = Rack::Handler.get('thin')
thin.run(DRb::WebSocket::RackApp.new(app), Host: "127.0.0.1", Port: 8002)

# Rack::Server.start({
#   app:    app,
#   server: 'thin',
#   Host:   '0.0.0.0',
#   Port:   8002,
#   signals: false,
# })
