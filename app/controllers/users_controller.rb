class UsersController < ApplicationController
  get '/' do
    erb :"/users/index"
  end
  
  get '/signup' do 
    if session[:user_id]
      redirect "/tweets"
    else
      erb :"/users/signup"
    end
  end
  
  post '/signup' do
    if params[:password] != ""
      @user = User.create(params)
    else
      redirect "/signup"
    end
    if @user.email != "" && @user.username != ""
      session[:user_id] = @user.id
      redirect "/tweets"
    else
      redirect "/signup"
    end
  end
  
  get '/login' do
    if session[:user_id]
      redirect "/tweets"
    else
      erb :"/users/login"
    end
  end
  
  post '/login' do 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end
  
  get '/logout' do 
    if session[:user_id]
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end
  post '/logout' do
    session.clear
    redirect "/login"
  end
  
  get '/users/:slug' do 
      @user = User.find_by_slug(params[:slug])
      erb :"/users/show"
  end
end
