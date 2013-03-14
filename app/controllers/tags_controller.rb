class TagsController < InheritedResources::Base
  respond_to :html, :json

  before_filter :logged_in_user, :only => [:new, :show, :create, :edit, :update, :destroy]

  belongs_to :user

  def create
    params[:tag][:color].gsub!(/^#/, "")
    create! { "/#{@user.username}" }
  end

  def update
    params[:tag][:color].gsub!(/^#/, "")
    update! { "/#{@user.username}" }
  end


  def destroy
    destroy! { "/#{@user.username}" }
  end

  protected
    def begin_of_association_chain
      @user = current_user;
    end

    def collection
      @tags ||= end_of_association_chain.order(:name) # .page(params[:page]).per(10)
    end

    def logged_in_user
      @request_user = User.find_by_username(params[:username])
      @request_user == current_user
    end

end
