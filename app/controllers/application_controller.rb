require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, "password_security"
    set :views, 'app/views'
  end
  
  get '/' do
    erb :"/users/home"
  end
  
  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    end
    erb :'/users/signup'
  end
  
  post "/signup" do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect "/signup"
    end
    user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    session[:user_id] = user.id
    redirect to "/tweets"
  end
  
  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect '/tweets'
    end
    erb :"/users/login"
  end
  
  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end
  
  get '/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
      redirect '/login'
    end
    redirect '/'
  end
  
  get '/tweets' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    @user = Helpers.current_user(session)
    @tweets = Tweet.select{|tweet| tweet.user_id == @user.id}
    @users = User.all
    @all_tweets = Tweet.all
    erb :"/tweets/index"
  end
  
  get '/tweets/new' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    erb :"/tweets/new"
  end
  
  post '/tweets' do
    user = Helpers.current_user(session)
    if params[:content].empty?
      redirect '/tweets/new'
    end
    tweet = Tweet.create(:content => params[:content], :user_id => user.id)
    redirect '/tweets'
  end
  
  get '/tweets/:id' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    @tweet = Tweet.find(params[:id])
    erb :"/tweets/show"
  end
  
  get '/tweets/:id/edit' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    @tweet = Tweet.find(params[:id])
    if Helpers.current_user(session).id != @tweet.user_id
      redirect '/tweets'
    end
    erb :"/tweets/edit"
  end
  
  post '/tweets/:id' do
    if params[:content].empty?
      redirect "/tweets/#{params[:id]}/edit"
    end
    tweet = Tweet.find(params[:id])
    tweet.update(:content => params[:content])
    tweet.save
    redirect "/tweets/#{tweet.id}"
  end
  
  post '/tweets/:id/delete' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    @tweet = Tweet.find(params[:id])
    if Helpers.current_user(session).id != @tweet.user_id
      redirect '/tweets'
    end
    @tweet.delete
    redirect '/tweets'
  end
  
  get '/users/:id' do
    @user = User.find(params[:id])
    @tweets = Tweet.select{|tweet| tweet.user_id == @user.id}
    erb :"/users/show"
  end
end



