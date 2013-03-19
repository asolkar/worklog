require 'test_helper'

class LogsControllerTest < ActionController::TestCase
  setup do
    login_user
    @log = logs(:one)
  end

  test "should not get index" do
    get :index, :username => @logged_in_user.username
    # assert_response :unprocessable_entity # FIXME: only for json (API)
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating logs listing not supported")
    assert_redirected_to user_path(username: @logged_in_user.username)
  end

  test "should get new" do
    get :new, :username => @logged_in_user.username
    assert_response :success
  end

  test "should create log" do
    log = get_log
    assert_difference('Log.count') do
      post :create, :username => @logged_in_user.username,
                    log: {  :id => log.id,
                            :name => log.name,
                            :description => log.description,
                            :user_id => log.user_id
                         }
    end

    assert_redirected_to log_path(@logged_in_user.username, assigns(:log))
  end

  test "should show log" do
    get :show, :username => @logged_in_user.username, id: @log
    assert_response :success
  end

  test "should get edit" do
    get :edit, :username => @logged_in_user.username, id: @log
    assert_response :success
  end

  test "should update log" do
    put :update, :username => @logged_in_user.username, id: @log,
                  log: {  :id => @log.id,
                          :name => @log.name,
                          :description => @log.description,
                          :user_id => @log.user_id
                       }
    assert_redirected_to log_path(@logged_in_user.username, assigns(:log))
  end

  test "should destroy log" do
    assert_difference('Log.count', -1) do
      delete :destroy, :username => @logged_in_user.username, id: @log
    end

    assert_redirected_to user_path(@logged_in_user.username)
  end

  def login_user
    @logged_in_user = users(:one)
    @request.session[:user_id] = @logged_in_user.id
  end

  def get_log(id=3)
    @log = Log.new
    @log.id = id
    @log.name = "New log name"
    @log.description = "New log description"
    @log.user_id = @logged_in_user.id
    return @log
  end
end
