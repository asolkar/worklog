class UsersController < InheritedResources::Base
  include GooglePlusSignInHelper

  respond_to :html, :json

  before_filter :require_user, :only => [:index, :show, :edit, :update, :update_gplus_id]
  before_filter :already_logged_in, :only => [:new]
  before_filter :no_user_listing, :only => [:index]
  before_filter :user_profile_url, :only => [:show]
  before_filter :load_belongings, :only => [:show]

  def associate_gplus_id
    resource[:gplus_id] = session[:gplus_id]
    resource[:gplus_refresh_token] = session[:token].to_hash[:refresh_token]

    $gplus_client = GooglePlusSignInHelper::GooglePlusClient.new
    @gplus = $gplus_client.get_profile(session, resource[:gplus_id])

    resource[:gplus_display_name] = @gplus[:name]
    resource[:gplus_profile_url] = @gplus[:profile_url]
    resource[:gplus_avatar_url] = @gplus[:img_url]

    update!
    flash[:notice] = "Associated Google+ ID " + resoutce[:gplus_id] + " to " + current_user.fullname
    redirect_to '/' and return
  end

  def update
    resource.avatar.store!
    update!
  end

  private

  def resource
    if params.has_key?(:username)
      @user = User.find_by_username(params[:username])
    else
      @user = current_user
    end
  end

  def already_logged_in
    if current_user
      flash[:notice] = "You are already logged as " + current_user.fullname
      redirect_to '/' and return
    end
  end

  def user_profile_url
    unless params.has_key?(:username)
      redirect_to "/#{current_user.username}"
    end
  end

  def no_user_listing
    flash[:alert] = "User listing is not allowed"
    redirect_to '/' and return
  end

  def load_belongings
    unless resource
      flash[:alert] = "User not found"
      redirect_to '/' and return
    end
    @logs = resource.logs.order(:created_at).page(params[:page]).per(10)
    @tags = resource.tags.order(:name) # .page(params[:page]).per(10)
  end
end
