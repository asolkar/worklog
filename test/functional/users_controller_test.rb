require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:users)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  test "should create native user" do
    user = get_user(:native)
    assert_difference('User.count') do
      post :create, user: { :id => user.id,
                            :username => user.username,
                            :email => user.email,
                            :fullname => user.fullname,
                            :password_digest => user.password_digest
                          }
    end

    assert_redirected_to logout_path
  end

  test "should create gplus user" do
    user = get_user(:gplus)
    assert_difference('User.count') do
      post :create, user: { :id => user.id,
                            :username => user.username,
                            :email => user.email,
                            :fullname => user.fullname,
                            :gplus_id => user.gplus_id
                          }
    end

    assert_redirected_to logout_path
  end

  test "should show logged in user" do
    login_user
    get :show, username: @user.username
    assert_response :success
  end

  test "should redirect non logged in user from show to login" do
    get :show, username: @user.username
    assert_redirected_to new_session_path
  end

  test "should edit logged in user" do
    login_user
    get :edit, username: @user.username
    assert_response :success
  end

  test "should redirect non logged in user from edit to login" do
    get :edit, username: @user.username
    assert_redirected_to new_session_path
  end

  test "should update logged in native user" do
    login_user
    put :update, username: @user.username,
          user: { :id => @user.id,
                  :username => @user.username,
                  :email => @user.email,
                  :fullname => @user.fullname,
                  :password_digest => @user.password_digest
                }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should update logged in gplus user" do
    login_user(:two)
    put :update, username: @user.username,
          user: { :id => @user.id,
                  :username => @user.username,
                  :email => @user.email,
                  :fullname => @user.fullname,
                  :gplus_id => @user.gplus_id
                }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should redirect non logged in user from update to login" do
    user = get_user(:native)
    put :update, username: user.username,
          user: { :id => user.id,
                  :username => user.username,
                  :email => user.email,
                  :fullname => user.fullname,
                  :password_digest => user.password_digest
                }
    assert_redirected_to new_session_path
  end

  #
  # FIXME: No support for destroy at the moment
  #
  test "should not destroy logged in user redirect to user profile" do
    login_user
    delete :destroy, username: @user.username
    assert_match(/not supported/, flash[:alert],
                 "No flash alert indicating user destruction not supported")
    assert_redirected_to user_path(@user)
  end

  test "should redirect non logged in user from destroy to login" do
    delete :destroy, username: @user.username
    assert_redirected_to new_session_path
  end

  private

  def get_user(type,id=3)
    user = User.new
    user.id = id
    user.username = "somename#{id}"
    user.email = "user#{id}@domain.com"
    user.fullname = "Full Name #{id}"

    if (type == :gplus)
      user.gplus_id = "191981762398716198#{id}"
    else
      user.gplus_id = nil
      user.password_digest = "S0meP4ss!#{id}"
      user.avatar = "/avatar/path#{id}.png"
    end
    return user
  end

  def login_user(user=:one)
    @logged_in_user = users(user)
    @logged_in_user_log = logs(user)
    @request.session[:user_id] = @logged_in_user.id
  end
end
