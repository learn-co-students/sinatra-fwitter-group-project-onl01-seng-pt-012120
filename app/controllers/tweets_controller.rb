class TweetsController < ApplicationController
get '/tweets' do 
    @tweets = Tweet.all
    if session[:user_id]
      erb :"/tweets/index"
    else 
      redirect "/login"
    end
  end
  
  get '/tweets/new' do
    if session[:user_id]
      erb :"/tweets/new"
    else 
      redirect "/login"
    end
  end
  
  post '/tweets' do
    if params[:content] != ""
      @tweet = Tweet.new(content: params[:content])
      @tweet.user = User.find(session[:user_id])
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    else 
      redirect "/tweets/new"
    end
  end
  
  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if session[:user_id]
      erb :"/tweets/show"
    else 
      redirect "/login"
    end
  end
  
  get '/tweets/:id/edit' do
    if session[:user_id]
      @tweet = Tweet.find(params[:id])
      if @tweet && User.find(session[:user_id]) == @tweet.user
        erb :"/tweets/edit"
      end
    else
      redirect "/login"
    end 
  end
  
  patch '/tweets/:id' do 
    @tweet = Tweet.find(params[:id])
    if params[:content] != ""
      @tweet.update(content: params[:content])
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end
      
  delete '/tweets/:id/delete' do 
    if session[:user_id] == Tweet.find(params[:id]).user_id
      Tweet.destroy(params[:id])
    end
    redirect "/tweets"
  end


end
