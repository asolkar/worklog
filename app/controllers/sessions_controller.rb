class SessionsController < ApplicationController
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
    if (session[:token])
      # Use either the refresh or access token to revoke if present.
      token = session[:token].to_hash[:refresh_token]
      token = session[:token].to_hash[:access_token] unless token

      # You could reset the state at this point, but as-is it will still stay unique
      # to this user and we're avoiding resetting the client state.
      # session.delete(:state)
      session.delete(:token)

      # Send the revocation request and return the result.
      revokePath = 'https://accounts.google.com/o/oauth2/revoke?token=' + token
      uri = URI.parse(revokePath)
      request = Net::HTTP.new(uri.host, uri.port)
      request.use_ssl = true
      status = request.get(uri.request_uri).code
      logger.debug "-------------------> sessions#destroy Cleaning Google+ session - Done " + status
    end
    redirect_to root_url, :notice => "Logged out!" and return
  end
end
