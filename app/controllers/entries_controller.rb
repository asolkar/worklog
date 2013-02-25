class EntriesController < InheritedResources::Base
  respond_to :html, :json

  rescue_from ActiveRecord::RecordNotFound, :with => :entry_not_found

  before_filter :require_user, :only => [:new, :show, :create, :edit, :update, :destroy]
  before_filter :save_referer, :only => [:edit, :destroy, :show]
  before_filter :logged_in_user, :only => [:new, :show, :create, :edit, :update, :destroy]

  after_filter :entry_not_found, :only => [:edit, :destroy, :show, :update]
  after_filter :not_users_entry, :only => [:edit, :destroy, :update]

  belongs_to :log

  def create
    create! { log_path(resource.log.user, resource.log) }
  end

  def destroy
    destroy! { log_path(resource.log.user, resource.log) }
  end

  protected
    def collection
      @entries ||= end_of_association_chain.order(:created_at).page(params[:page]).per(5)
    end

  private
    def save_referer
      session[:return_to] ||= request.referer
      session[:return_to] ||= root_path # If empty, go to root
    end

    def entry_not_found
      unless @entry
        flash[:alert] = "Could not find entry with ID " + params[:username] + " within log ID " + params[:log_id]
        redirect_to session.delete(:return_to)
        return false
      end
    end

    def not_users_entry
      unless @entry.log.user == current_user
        flash[:alert] = "You are not to owner of this Log. You cannot edit entries within"
        redirect_to session.delete(:return_to)
        return false
      end
    end

    def logged_in_user
      @request_user = User.find_by_username(params[:username])
      @request_user == current_user
    end
end
