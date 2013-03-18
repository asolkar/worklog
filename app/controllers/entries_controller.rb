class EntriesController < InheritedResources::Base
  respond_to :html, :json

  rescue_from ActiveRecord::RecordNotFound, :with => :entry_not_found

  before_filter :require_user, :only => [:index, :new, :show, :create, :edit, :update, :destroy]
  before_filter :save_referer, :only => [:index, :edit, :destroy, :show]
  before_filter :logged_in_user, :only => [:index, :new, :show, :create, :edit, :update, :destroy]
  before_filter :generate_tags, :only => [:create]

  after_filter :entry_not_found, :only => [:edit, :destroy, :show, :update]
  after_filter :not_users_entry, :only => [:edit, :destroy, :update]

  belongs_to :log

  def index
    flash[:alert] = "Listing entries is not supported"
    @log = @request_user.logs.find(params[:log_id])
    redirect_to log_path(@log.user, @log)
    return false
  end

  def new
    flash[:alert] = "Standalone new entry form is not supported"
    @log = @request_user.logs.find(params[:log_id])
    redirect_to log_path(@log.user, @log)
    return false
  end

  def show
    flash[:alert] = "Standalone entry display is not supported"
    redirect_to log_path(resource.log.user, resource.log)
    return false
  end

  def edit
    flash[:alert] = "Standalone edit entry form is not supported"
    redirect_to log_path(resource.log.user, resource.log)
    return false
  end

  def create
    create! { log_path(resource.log.user, resource.log) }
  end

  def update
    update! { log_path(resource.log.user, resource.log) }
  end

  def destroy
    destroy! { log_path(resource.log.user, resource.log) }
  end

  protected
    def collection
      @entries ||= end_of_association_chain.order(:created_at).page(params[:page]).per(3)
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

    def generate_tags
      if (params[:tags]) then
        @tags = params[:tags].collect { |id| current_user.tags.find(id).first }
      end
    end
end
