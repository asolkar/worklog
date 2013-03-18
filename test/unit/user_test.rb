require 'test_helper'
require 'awesome_print'

class UserTest < ActiveSupport::TestCase

  setup :initialize_user

  def teardown
    # ap @user.errors
    @user = nil
  end

  #
  # For native accounts
  #
  test "should not create native without username" do
    @user.gplus_id = nil
    @user.email = "user@domain.com"
    @user.fullname = "Full Name"
    @user.password_digest = "S0meP4ss!"
    assert !@user.save, "Created native user without username"
    assert_match(/be blank/, @user.errors[:username].first,
                 "No message about empty username - #{@user.errors[:username]}")
  end

  test "should not create native without email" do
    @user.gplus_id = nil
    @user.username = "somename"
    @user.fullname = "Full Name"
    @user.password_digest = "S0meP4ss!"
    assert !@user.save, "Created native user without email"
    assert_match(/be blank/, @user.errors[:email].first,
                 "No message about empty username - #{@user.errors[:email]}")
  end

  test "should not create native without fullname" do
    @user.gplus_id = nil
    @user.username = "somename"
    @user.email = "user@domain.com"
    @user.password_digest = "S0meP4ss!"
    assert !@user.save, "Created native user without fullname"
    assert_match(/be blank/, @user.errors[:fullname].first,
                 "No message about empty username - #{@user.errors[:fullname]}")
  end

  test "should not create native without password_digest" do
    @user.gplus_id = nil
    @user.username = "somename"
    @user.email = "user@domain.com"
    @user.fullname = "Full Name"
    assert !@user.save, "Created native user without password digest"
    assert_match(/be blank/, @user.errors[:password_digest].first,
                 "No message about empty username - #{@user.errors[:password_digest]}")
  end

  test "should create native without avatar" do
    @user.gplus_id = nil
    @user.username = "somename"
    @user.email = "user@domain.com"
    @user.fullname = "Full Name"
    @user.password_digest = "S0meP4ss!"
    assert @user.save, "Did not create native user without avatar"
  end

  #
  # For gplus accounts
  #
  test "should not create gplus without username" do
    @user.gplus_id = "191981762398716198"
    @user.email = "user@domain.com"
    @user.fullname = "Full Name"
    assert !@user.save, "Created gplus user without username"
    assert_match(/be blank/, @user.errors[:username].first,
                 "No message about empty username - #{@user.errors[:username]}")
  end

  test "should not create gplus without email" do
    @user.gplus_id = "191981762398716198"
    @user.username = "somename"
    @user.fullname = "Full Name"
    assert !@user.save, "Created gplus user without email"
    assert_match(/be blank/, @user.errors[:email].first,
                 "No message about empty username - #{@user.errors[:email]}")
  end

  test "should not create gplus without fullname" do
    @user.gplus_id = "191981762398716198"
    @user.username = "somename"
    @user.email = "user@domain.com"
    assert !@user.save, "Created gplus user without full name"
    assert_match(/be blank/, @user.errors[:fullname].first,
                 "No message about empty username - #{@user.errors[:fullname]}")
  end

  test "should create gplus without avatar" do
    @user.gplus_id = "191981762398716198"
    @user.username = "somename"
    @user.email = "user@domain.com"
    @user.fullname = "Full Name"
    assert @user.save, "Did not create gplus user without avatar"
  end

  private

  def initialize_user
    @user = User.new
    @user.id = 3
  end
end
