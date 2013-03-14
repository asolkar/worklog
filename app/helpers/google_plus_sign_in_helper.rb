module GooglePlusSignInHelper
  require 'uri'
  require 'net/http'

  class GooglePlusClient
    #
    # Set up the client
    #
    def initialize
      $authorization = Signet::OAuth2::Client.new(
          :authorization_uri => Settings.gplus_signin.auth_uri,
          :token_credential_uri => Settings.gplus_signin.token_uri,
          :client_id => Settings.gplus_signin.client_id,
          :client_secret => Settings.gplus_signin.client_secret,
          :redirect_uri => Settings.gplus_signin.redirect_uris.first,
          :scope => 'https://www.googleapis.com/auth/plus.login')
      $client = Google::APIClient.new(
        :application_name => Settings.app_name,
        :application_version => '0.1')
    end

    #
    # Upgrade the code into a token object.
    #
    def exchange_token(request)
      Rails.logger.debug "Auth : #{$authorization}"
      $authorization.code = request.body.read
      $authorization.fetch_access_token!
      $client.authorization = $authorization

      # Verify the issued token matches the user and client.
      oauth2 = $client.discovered_api('oauth2','v2')
      tokeninfo = JSON.parse($client.execute(oauth2.tokeninfo,
                    :access_token => $client.authorization.access_token,
                    :id_token => $client.authorization.id_token).response.body)

      # Serialize and store the token in the user's session.
      token_pair = GooglePlusSignInHelper::TokenPair.new
      token_pair.update_token!($client.authorization)

      return tokeninfo, token_pair
    end

    #
    # Use Google+ API to get profile of a user
    #
    def get_profile(session, user_id)
      $client.authorization.update_token!(session[:token].to_hash)
      plus = $client.discovered_api('plus')

      Rails.logger.debug "TokenPair: #{$client.authorization.to_yaml}"
      result = $client.execute(
                  :api_method => plus.people.get,
                  :parameters => {'userId' => user_id})

      Rails.logger.debug "GoogleClient: ---------------------------------> "
      Rails.logger.debug "GoogleClient: NM #{result.data['displayName']}"
      Rails.logger.debug "GoogleClient: IM #{result.data['image']['url']}"
      Rails.logger.debug "GoogleClient: PR #{result.data['url']}"
      Rails.logger.debug "GoogleClient: ---------------------------------> "

      @profile = Hash.new
      @profile[:name] = result.data['displayName']
      @profile[:profile_url] = result.data['url']

      # Avatar sizes
      @profile[:img_url] = result.data['image']['url']
      @profile[:img_url].gsub!(/sz=\d+$/, "")

      @profile[:img_thumb_url] = @profile[:img_url] + 'sz=100'
      @profile[:img_tiny_url] = @profile[:img_url] + 'sz=32'
      @profile[:img_badge_url] = @profile[:img_url] + 'sz=15'

      return @profile
    end

    #
    # Static helper function used in other methods to clear the Google+ part of session
    # variables
    #
    def self.clean_google_plus_session(session)
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
        Rails.logger.debug "clean_google_plus_session Cleaned Google+ session - " + status
      end
    end
  end

  #
  # Serializes and deserializes the token.
  #
  class TokenPair
    def update_token!(object)
      @refresh_token = object.refresh_token
      @access_token = object.access_token
      @expires_in = object.expires_in
      @issued_at = object.issued_at
    end

    def to_hash
      return {
        :refresh_token => @refresh_token,
        :access_token => @access_token,
        :expires_in => @expires_in,
        :issued_at => Time.at(@issued_at)}
    end
  end

end
