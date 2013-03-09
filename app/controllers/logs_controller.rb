class LogsController < InheritedResources::Base
  respond_to :html, :json

  # rescue_from ActiveRecord::RecordNotFound, :with => :log_not_found

  # before_filter :require_user, :only => [:new, :show, :create, :edit, :update, :destroy]
  before_filter :save_referer, :only => [:edit, :destroy, :show]
  before_filter :load_entries, :only => [:show]
  before_filter :logged_in_user, :only => [:new, :show, :create, :edit, :update, :destroy]

  after_filter :log_not_found, :only => [:edit, :destroy, :show]
  after_filter :not_users_log, :only => [:edit, :destroy]

  belongs_to :user

  def create
    create! { log_path(resource.user, resource) }
  end

  def destroy
    destroy! { "/#{@user.username}" }
  end

  protected
    def begin_of_association_chain
      @user = current_user;
    end

    def collection
      @logs ||= end_of_association_chain.order(:created_at).page(params[:page]).per(10)
    end

  private
    def save_referer
      session[:return_to] ||= request.referer
      session[:return_to] ||= root_path # If empty, go to root
    end

    def log_not_found
      unless @log
        flash[:alert] = "Could not find log with ID " + params[:id]
        redirect_to session.delete(:return_to)
        return false
      end
    end

    def logged_in_user
      @request_user = User.find_by_username(params[:username])
      @request_user == current_user
    end

    def not_users_log
      unless @log.user == current_user
        flash[:alert] = "You are not to owner of this log. You cannot edit it"
        redirect_to session.delete(:return_to)
        return false
      end
    end

    def load_entries
      @resource_entries = resource.entries.order('created_at DESC').page(params[:page]).per(10)
      # logger.debug "Resources: #{resource_entries.attributes.inspect}"
      if (!params[:name].blank?) then
        @resource_entries ||= @resource_entries.tagged_with(params[:name])
      end
      @entry_groups = @resource_entries.group_by { |m| m.created_at.beginning_of_day }
      # @entry_groups ||= @entry_groups.page(params[:page]).per(1)

      @gplus = GooglePlusSignInHelper::GooglePlusClient.get_profile(@user[:gplus_id])

      logger.debug "Res: #{@gplus}"
      logger.debug "User: #{@user}"
    end
end
