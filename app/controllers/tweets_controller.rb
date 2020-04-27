class TweetsController < ApplicationController

	get "/tweets" do
		if logged_in?
			@tweets = Tweet.order(id: :desc)

			erb :'tweets/index'
		else
			redirect "/login"
		end
	end

	get "/tweets/new" do
		if logged_in?
			erb :'tweets/new'
		else
			redirect "/login"
		end
	end

	get "/tweets/:id" do
		if logged_in?
			@tweet = Tweet.find(params[:id])
			erb :'/tweets/show'
		else
			redirect "/login"
		end
	end

	get "/tweets/:id/edit" do
		if logged_in?
			if current_user.tweet_ids.include?(params[:id].to_i)
				@tweet = Tweet.find(params[:id])
				erb :'/tweets/edit'
			else
				redirect "/tweets"
			end
		else
			redirect "/login"
		end
	end

	patch "/tweets/:id" do
		if logged_in?
			if current_user.tweet_ids.include?(params[:id].to_i)
				tweet = Tweet.find(params[:id])
				tweet.update(content: params[:content])

				redirect "/tweets/#{tweet.id}/edit"
			else
				redirect "/tweets/#{tweet.id}/edit"
			end
		else
			redirect "/login"
		end
	end

	post "/tweets" do
		user = current_user
		user.tweets.new(content: params[:content])
		if user.save
			redirect "/tweets"
		else
			redirect "tweets/new"
		end
	end

	delete "/tweets/:id" do
		if logged_in?
			if current_user.tweet_ids.include?(params[:id].to_i)
				tweet = Tweet.find(params[:id])
				tweet.destroy
				
				redirect "/tweets"
			else
				redirect "/tweets"
			end
		else
			redirect "/login"
		end
	end
end
