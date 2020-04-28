class UsersController < ApplicationController

    get "/login" do
        erb :"/users/login"
    end

    post "/login" do
        redirect "/tweets"
    end

    get "/signup" do
        erb :"/users/signup"
    end

    post "/signup" do

        redirect "/login"
    end

    get "/logout" do

        redirect "/login"
    end
end
