class TweetsController < ApplicationController

  get '/tweets' do 
    if !logged_in?
      redirect to '/login'
    end 
    @tweets = current_user.tweets
    erb :'/tweets/index' 
  end 
  
  get '/tweets/new' do 
    if !logged_in?
      redirect to '/login'
    end 
    erb :'/tweets/new'
  end 
  
  post '/tweets' do 
    if !logged_in?
      redirect to '/login'
    else params[:content] == ""
      redirect to "/tweets/new"
    end 
    
    @tweet = Tweet.create(content: params[:content], :user_id => user.id)

    redirect to '/tweets'
  end 
  
  get '/tweets/:id' do
    if !logged_in?
      redirect to '/login'
    end 
    @tweet = Tweet.find_by_id(params[:id])
    erb :'tweets/show'
   end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect to '/login'
    end 
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet && @tweet.user == current_user
      erb :'tweets/edit'
    else
      redirect to '/tweets'
    end
  end

  patch '/tweets/:id' do
    if !logged_in?
      redirect to '/login'
    end 
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user == current_user
        if @tweet.update(content: params[:content])
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/#{@tweet.id}/edit"
        end
      else
        redirect to '/tweets'
      end
    end
  end

  delete '/tweets/:id/delete' do
    redirect '/login' if !logged_in?
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet && @tweet.user == current_user
      @tweet.delete
    end
    redirect to '/tweets'
  end

end
