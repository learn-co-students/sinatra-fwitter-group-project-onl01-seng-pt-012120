class TweetsController < ApplicationController

  get '/tweets' do
    if Helpers.is_logged_in?(session)
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect to '/users/login'
    end
  end

  get '/tweets/new' do
    @user = Helpers.current_user(session)
    if @user.nil?
      redirect to '/login'
    else
      erb :'tweets/new'
    end

  end

  post '/tweets' do
    @user = Helpers.current_user(session)
    if @user.nil?
      redirect to '/login'
    elsif params[:content].empty?
      redirect to '/tweets/new'
    else
      @user.tweets.build({:content => params[:content], :user_id => params[:user_id]})
      @user.save
    end
    redirect to '/tweets'
  end

  get '/tweets/:id' do
    redirect to '/login' unless Helpers.is_logged_in?(session)
    @tweet = Tweet.find(params[:id])

    erb :'/tweets/show'
  end

  get '/tweets/:id/edit' do
    redirect to '/login' unless Helpers.is_logged_in?(session)

    @tweet = Tweet.find(params[:id])
    if @tweet.user == Helpers.current_user(session)
        erb :'/tweets/edit'
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])

    if params[:tweet][:content].empty?
      redirect to "/tweets/#{@tweet.id}/edit"
    end

    @tweet.update(params[:tweet])
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"

  end

  delete '/tweets/:id/delete' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      if @tweet.user == Helpers.current_user(session)
        @tweet = Tweet.find_by_id(params[:id])
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

end 
