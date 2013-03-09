class SessionsController < ApplicationController
  include GooglePlusSignInHelper

  def new
    if current_user
      flash[:notice] = "You are already logged as " + current_user.fullname
      redirect_to "/#{current_user.username}" and return
    end
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/#{user.username}", :notice => "Welcome " + user.fullname + "! You are logged in." and return
    else
      flash.now.alert = "Invalid username or password"
      render "new" and return
    end
  end

  def gpluscreate
    if (session[:gplus_id])
      user = User.find_by_gplus_id(params[:gplus_id])
      if user
        session[:user_id] = user.id
        redirect_to "/#{user.username}", :notice => "Welcome " + user.fullname + "! You are logged in." and return
      else
        flash.now.alert = "Google+ ID " + session[:gplus_id] + " is not connected to Worklog"
        render "new" and return
      end
    else
      flash.now.alert = "No Google+ login detected"
      render "new" and return
    end
  end

  def destroy
    #
    # Application owned session parameters
    #
    session.delete(:user_id)
    session.delete(:gplus_id)
    session.delete(:username)

    #
    # Google+ owned session parameters
    #
    GooglePlusClient.clean_google_plus_session(session)

    redirect_to root_url, :notice => "Logged out!" and return
  end
end
