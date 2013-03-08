require 'google/api_client'
require 'google/api_client/client_secrets'
require 'uri'
# use Rack::Session::Pool, :expire_after => 86400 # 1 day

class GooglePlusSignInController < ApplicationController

  before_filter :ready_client, :only => [:connect]

  def ready_client
    # Build the global client
    $credentials = Google::APIClient::ClientSecrets.load
    logger.debug "Creds: #{$credentials.authorization_uri}"
    logger.debug "       #{$credentials.token_credential_uri}"
    logger.debug "       #{$credentials.client_id}"
    logger.debug "       #{$credentials.client_secret}"
    logger.debug "       #{$credentials.redirect_uris.first}"
    $authorization = Signet::OAuth2::Client.new(
        :authorization_uri => $credentials.authorization_uri,
        :token_credential_uri => $credentials.token_credential_uri,
        :client_id => $credentials.client_id,
        :client_secret => $credentials.client_secret,
        :redirect_uri => $credentials.redirect_uris.first,
        :scope => 'https://www.googleapis.com/auth/plus.login')
    $client = Google::APIClient.new(
      :application_name => 'Worklog',
      :application_version => '0.1')
  end

  def connect
    # Get the token from the session if available or exchange the authorization
    # code for a token.
    if !session[:token]
      # Make sure that the state we set on the client matches the state sent
      # in the request to protect against request forgery.
      if session[:state] == params[:state]
        # Upgrade the code into a token object.
        logger.debug "Auth : #{$authorization}"
        $authorization.code = request.body.read
        $authorization.fetch_access_token!
        $client.authorization = $authorization

        # Verify the issued token matches the user and client.
        oauth2 = $client.discovered_api('oauth2','v2')
        tokeninfo = JSON.parse($client.execute(oauth2.tokeninfo,
            :access_token => $client.authorization.access_token,
            :id_token => $client.authorization.id_token).response.body)
        if tokeninfo['error']
          logger.debug "Session token error: #{tokeninfo['error']}"
          render  :json => {:status => "error",
                            :message => "Session token error: #{tokeninfo['error']}"},
                  :status => :unauthorized and return
        end
        if tokeninfo['issued_to'] != $credentials.client_id
          logger.debug "Session token issued-to mismatch: #{tokeninfo['issued_to']} != #{$credentials.client_id}"
          render  :json => {:status => "error",
                            :message => "Session token issued-to mismatch: #{tokeninfo['issued_to']} != #{$credentials.client_id}"},
                  :status => :unauthorized and return
        end
        # if tokeninfo['user_id'] != params[:gplus_id]
        #   logger.debug "Session token user-id mismatch: #{tokeninfo['user_id']} != #{params[:gplus_id]}"
        #   render :nothing => true, :status => :unauthorized
        # end

        # Serialize and store the token in the user's session.
        token_pair = GooglePlusSignInHelper::TokenPair.new
        token_pair.update_token!($client.authorization)

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
          logger.debug("User by Google+ ID #{tokeninfo['user_id']} = #{user.fullname}")
          if user
            session[:user_id] = user.id
            session[:username] = user.username
            session[:token] = token_pair
            session[:gplus_id] = tokeninfo['user_id']
            render  :json => {:status => "gplus_existing",
                              :message => "Google+ id #{session['gplus_id']} just logged in"},
                    :status => 200 and return
          else
            session[:token] = token_pair
            clean_session
            render  :json => {:status => "error",
                              :message => "Google+ id #{tokeninfo['user_id']} not associated with any user"},
                    :status => :unauthorized and return
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

  def clean_session
    if (session[:token])
      logger.debug "-------------------> Cleaning Google+ session"
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
      logger.debug "-------------------> Cleaning Google+ session - Done " + status
    end
  end

  def disconnect
    if (session[:token])
      clean_session
    else
      flash[:alert] = "You are logged out"
      redirect_to '/' and return
    end
  end
end
