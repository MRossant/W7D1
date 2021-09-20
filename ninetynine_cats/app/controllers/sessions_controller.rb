class SessionsController < ApplicationController

    before_action :require_log_out, only: [:new, :create]

    def new
        @user = User.new
        # render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])

        if @user
            # new_session_token = @user.reset_session_token!
            # session[:session_token] = new_session_token
            login_user!(@user)
            redirect_to cats_url
        else
            redirect_to cats_url
            #render :new
        end
    end

    def destroy
        @current_user.reset_session_token! if logged_in?

        session[:session_token] = nil
        @current_user = nil
    end
end
