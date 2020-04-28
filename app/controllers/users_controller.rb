class UsersController < ApplicationController

    get "/login" do
        erb :"/users/login"
    end

    post "/login" do

    end

    get "/signup" do
        erb :"/users/signup"
    end

    post "/signup" do

    end

    get "/logout" do

        redirect "/login"
    end
end
