require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
  
  enable :sessions
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, "secret"
  end
  
  get '/' do
    erb :'/index'
  end
  
  get '/signup' do
    if !Helpers.is_logged_in?(session)
      erb :"/users/signup"
    else
      redirect "/tweets"
    end
  end
  
  post '/signup' do
    # Checking to see if all the values are empty
    params.each do |key, value|
      if value.empty?
        redirect "/signup"
      end
    end
    
    # After confirming that all values aren't empty, we now create the user
    user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    session[:user_id] = user.id
    redirect "/tweets"
  end
  
  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect "/tweets"
    else
      erb :"/users/login"
    end
  end
  
  post '/login' do
    user = User.find_by(:username => params[:username])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
    
  end
  
  get '/tweets' do
    @user = User.find_by(:username => params[:username])
    if !Helpers.is_logged_in?(session)
      redirect "/login"
    else
      @tweets = Tweet.all
      erb :"/tweets/index"
    end
  end
  
  get '/users/:slug' do
    slug = params[:slug]
    @user = User.find_by_slug(params[:slug])
    
    erb :"/users/show"
  end
  
  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :"/tweets/new"
    else
      redirect "/login"
    end
  end
  
  post '/tweets' do
    user = Helpers.current_user(session)
    params[:user_id] = user.id
    if params[:content].empty?
      redirect "/tweets/new"
    else
      tweet = Tweet.create(:content => params[:content], :user_id => params[:user_id])
      
      redirect "/tweets"
    end
  end
  
  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session) 
      erb :"/tweets/single_tweet"
    else
      redirect "/login"
    end
  end
  
  get '/tweets/:id/edit' do
    if Helpers.is_logged_in?(session) 
      @tweet = Tweet.find(params[:id])
      if Helpers.current_user(session).id == @tweet.user_id
        erb :"/tweets/edit_tweet"
      else
        redirect "/tweets"
      end
    else
      redirect "/login"
    end
    
  end
  
  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if params[:content].empty?
      redirect "/tweets/#{tweet.id}/edit"
    else
      tweet.update(:content => params[:content])
      tweet.save
      redirect "/tweets/#{tweet.id}"
    end
  end
  
  post '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if !Helpers.is_logged_in?(session)
      redirect "/login"
    end
    
    if Helpers.current_user(session).id != @tweet.user_id
      redirect "/tweets"
    end
    
    @tweet.delete
    redirect "/tweets"
  end
  
  get '/logout' do
    @user = User.find_by(:username => params[:username])
    if Helpers.is_logged_in?(session)
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end
  
  

end
