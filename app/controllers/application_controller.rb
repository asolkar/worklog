class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @c_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end

  def require_user
    unless current_user
      # store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_session_path
      return false
    end
  end

  helper_method :current_user, :require_user
end
