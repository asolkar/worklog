require 'google/api_client'
require 'uri'
# use Rack::Session::Pool, :expire_after => 86400 # 1 day

class GooglePlusSignInController < ApplicationController
  include GooglePlusSignInHelper

  #
  # This is the OAuth callback registered with Google+ API Client access
  #
  def connect
    # Get the token from the session if available or exchange the authorization
    # code for a token.
    if !session[:token]
      # Make sure that the state we set on the client matches the state sent
      # in the request to protect against request forgery.
      if session[:state] == params[:state]
        $gplus_client = GooglePlusSignInHelper::GooglePlusClient.new
        tokeninfo, token_pair = $gplus_client.exchange_token(request)
        if tokeninfo['error']
          logger.debug "Session token error: #{tokeninfo['error']}"
          render  :json => {:status => "error",
                            :message => "Session token error: #{tokeninfo['error']}"},
                  :status => :unauthorized and return
        end
        if tokeninfo['issued_to'] != Settings.gplus_signin.client_id
          logger.debug "Session token issued-to mismatch: #{tokeninfo['issued_to']} != #{Settings.gplus_signin.client_id}"
          render  :json => {:status => "error",
                            :message => "Session token issued-to mismatch: #{tokeninfo['issued_to']} != #{Settings.gplus_signin.client_id}"},
                  :status => :unauthorized and return
        end

        if current_user
          #
          # There is already a user logged in. If current user is not connected to
          # this gplus_id, make the connection.
          #
          session[:token] = token_pair
          session[:gplus_id] = tokeninfo['user_id']
          if current_user.gplus_id.blank?
            render  :json => {:status => "gplus_associate",
                              :message => "Google+ id #{session['gplus_id']} just logged in"},
                    :status => 200 and return
          else
            render  :json => {:status => "gplus_existing",
                              :message => "Google+ id #{session['gplus_id']} just logged in"},
                    :status => 200 and return
          end
        else
          user = User.find_by_gplus_id(tokeninfo['user_id'])
          if user
            logger.debug("User by Google+ ID #{tokeninfo['user_id']} = #{user.fullname}")
            session[:user_id] = user.id
            session[:username] = user.username
            session[:token] = token_pair
            session[:gplus_id] = tokeninfo['user_id']
            render  :json => {:status => "gplus_existing",
                              :message => "Google+ id #{session['gplus_id']} just logged in"},
                    :status => 200 and return
          else
            session[:token] = token_pair
            session[:gplus_id] = tokeninfo['user_id']
            # GooglePlusSignInHelper::GooglePlusClient.clean_google_plus_session(session)
            render  :json => {:status => "gplus_create",
                              :message => "Google+ id #{tokeninfo['user_id']} not associated with any user"},
                    :status => 200 and return
          end
        end
      else
        render  :json => {:status => "error",
                          :message => "Unauthorized access"},
                :status => :unauthorized and return
      end
    else
      logger.debug "Session has token : #{session}"
      render  :json => {:status => "gplus_logged_in",
                        :message => "Google+ id #{session['gplus_id']} already logged in"},
              :status => 200 and return
    end
  end

  #
  # Disconnects user from the Google+ API auth. Used to log off a user
  #
  def disconnect
    if (session[:token])
      GooglePlusSignInHelper::GooglePlusClient.clean_google_plus_session(session)
    else
      flash[:alert] = "You are logged out"
      redirect_to '/' and return
    end
  end
end
