class UsersController < ApplicationController

    get "/login" do
        if logged_in?
            redirect "/tweets"
        else
            erb :"/users/login"
        end
    end

    post "/login" do
        if params[:username] != "" && params[:password] != ""
            @user = User.find_by(username: params[:username])
            if @user && @user.authenticate(params[:password])
                session[:user_id] = @user.id
                redirect "/tweets"
            else 
                redirect "/login"
            end
        else 
            redirect "/login"
        end
    end

    get "/signup" do
        if logged_in?
            redirect "/tweets"
        else
            erb :"/users/signup"
        end
    end

    post "/signup" do
        if params[:username] != "" && params[:email] != "" && params[:password] != ""
            @user = User.create(params)
            session[:user_id] = @user.id
            redirect "/tweets"
        else
            redirect "/signup"
        end
    end

    get "/logout" do
        if logged_in?
            session.clear
            redirect "/login"
        else
            redirect "/"
        end
    end

    get "/users/:slug" do
        @user = User.find_by_slug(params[:slug])
        
        erb :"/users/show"
    end
end
