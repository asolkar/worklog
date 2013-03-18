require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    login_user
    @entry = entries(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:entries)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  test "should create entry" do
    assert_difference('Entry.count') do
      post :create, entry: { body: "Test body" }, user_id:@logged_in_user.id, log_id: @logged_in_user_log.id
    end

    assert_redirected_to log_path(username: @logged_in_user.username, id: @logged_in_user_log.id)
  end

  # test "should show entry" do
  #   get :show, id: @entry
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @entry
  #   assert_response :success
  # end

  # test "should update entry" do
  #   put :update, id: @entry, entry: {  }
  #   assert_redirected_to entry_path(assigns(:entry))
  # end

  # test "should destroy entry" do
  #   assert_difference('Entry.count', -1) do
  #     delete :destroy, id: @entry
  #   end

  #   assert_redirected_to entries_path
  # end

  def login_user
    @logged_in_user = users(:one)
    @logged_in_user_log = logs(:one)
    @request.session[:user_id] = @logged_in_user.id
  end
end
