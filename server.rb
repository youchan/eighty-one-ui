require 'sinatra'
require 'opal'
require 'opal/sprockets'
require 'sinatra/activerecord'

if development?
  require 'sinatra/reloader'
end

class Server < Sinatra::Base
  opal = Opal::Sprockets::Server.new do |server|
    server.append_path 'app'
    server.append_path 'assets'
    Opal.use_gem 'hyalite'
    Opal.use_gem 'menilite'
    Opal.use_gem 'opal-drb'
    Opal.paths.each {|path| server.append_path path }

    server.main = 'application'
  end

  configure do
    set opal: opal
    enable :sessions
    set :protection, except: :json_csrf
  end

  get '/' do
    if @session = Session.auth(self.session[:session_id])
      haml :index
    else
      redirect to('/login')
    end
  end

  get "/game" do
    haml :index
  end

  get '/login' do
    haml :login
  end

  get '/signup' do
    haml :signup
  end

  get "/favicon.ico" do
  end
end

