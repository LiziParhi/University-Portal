require 'sinatra'
require 'slim'
require './student'
require 'sass'

 configure do
  enable :sessions
  set :username, 'lizi'
  set :password, 'parhi'
end

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] ||"sqlite3://#{Dir.pwd}/test2.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end



get('/css/styles.css') do 
 scss :stylup 
end



get '/' do
   @title = "home"
  slim :home
end

get '/home' do
   @title = "home"
  slim :home
end


get '/about' do
  
  @title = "All About This Website"
  slim :about
end

get '/contact' do
   @title = "contact"
  slim :contact
end



not_found do
   @title = "not found"
  slim :not_found
end

get '/login' do
   @title = "login page"
  slim :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/students')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
   session[:username] = nil
  slim :signout
end

