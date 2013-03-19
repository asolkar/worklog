require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    login_user
    @entry = entries(:one)
  end

  test "should not get index" do
    get :index, :username => @logged_in_user.username, :log_id => @logged_in_user_log.id
    # assert_response :unprocessable_entity # FIXME: only for json (API)
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating entry listing not supported")
    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should not get new" do
    get :new, :username => @logged_in_user.username, :log_id => @logged_in_user_log.id
    # assert_response :unprocessable_entity # FIXME: only for json (API)
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating standalone new entry form not supported")
    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should create entry" do
    assert_difference('Entry.count') do
      post :create, entry: { body: "Test body" }, username:@logged_in_user.username, log_id: @logged_in_user_log.id
    end

    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should not show entry" do
    get :show, id: @entry, :username => @logged_in_user.username, :log_id => @logged_in_user_log.id
    # assert_response :unprocessable_entity # FIXME: only for json (API)
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating standalone entry display not supported")
    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should get edit" do
    get :edit, id: @entry, :username => @logged_in_user.username, :log_id => @logged_in_user_log.id
    # assert_response :unprocessable_entity # FIXME: only for json (API)
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating standalone edit entry form not supported")
    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should update entry" do
    put :update, id: @entry, entry: { body: "Updated Test body" }, :username => @logged_in_user.username, :log_id => @logged_in_user_log.id
    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, id: @entry, :username => @logged_in_user.username, :log_id => @logged_in_user_log
    end

    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  def login_user
    @logged_in_user = users(:one)
    @logged_in_user_log = logs(:one)
    @request.session[:user_id] = @logged_in_user.id
  end
end
