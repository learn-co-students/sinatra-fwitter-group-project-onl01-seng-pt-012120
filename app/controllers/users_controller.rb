class UsersController < ApplicationController


	get "/login" do
		if logged_in?
			redirect "/tweets"
		else
			erb :'users/login'
		end
	end

	get "/signup" do
		if !logged_in?
			erb :'users/signup'
		else
			redirect "/tweets"
		end
	end

	post "/signup" do
		user = User.new(params)
		if user.save
			login(params[:username], params[:password])
		else
			redirect "/signup"
		end
	end

	post "/login" do
		login(params[:username], params[:password])
	end

	get "/logout" do
		if logged_in?
			logout

			redirect "/login"
		else
			redirect "/"
		end
	end

	get "/users/:slug" do
		@user = User.friendly.find(params[:slug]) 

		erb :'/users/show'
	end


end
