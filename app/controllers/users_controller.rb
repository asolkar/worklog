class UsersController < InheritedResources::Base
  respond_to :html, :json

  before_filter :require_user, :only => [:index, :show, :edit, :update]
  before_filter :already_logged_in, :only => [:new]
  before_filter :no_user_listing, :only => [:index]
  before_filter :user_profile_url, :only => [:show]
  before_filter :load_belongings, :only => [:show]

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
      redirect_to '/'
      return
    end
  end

  def user_profile_url
    unless params.has_key?(:username)
      redirect_to "/#{current_user.username}"
    end
  end


  def no_user_listing
    flash[:alert] = "User listing is not allowed"
    redirect_to '/'
    return
  end

  def load_belongings
    unless resource
      flash[:alert] = "User not found"
      redirect_to '/'
      return
    end
    @logs = resource.logs.order(:created_at).page(params[:page]).per(10)
    @tags = resource.tags.order(:name) # .page(params[:page]).per(10)
  end
end
