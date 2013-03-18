require 'test_helper'
require 'awesome_print'

class UserTest < ActiveSupport::TestCase

  # setup :initialize_user

  # def teardown
  # end

  #
  # For native accounts
  #
  test "should not create native without username" do
    user = get_user(:native)
    user.username = nil
    assert !user.save, "Created native user without username"
    assert_match(/be blank/, user.errors[:username].first,
                 "No message about empty username - #{user.errors[:username]}")
  end

  test "should not create native without email" do
    user = get_user(:native)
    user.email = nil
    assert !user.save, "Created native user without email"
    assert_match(/be blank/, user.errors[:email].first,
                 "No message about empty username - #{user.errors[:email]}")
  end

  test "should not create native without fullname" do
    user = get_user(:native)
    user.fullname = nil
    assert !user.save, "Created native user without fullname"
    assert_match(/be blank/, user.errors[:fullname].first,
                 "No message about empty username - #{user.errors[:fullname]}")
  end

  test "should not create native without password_digest" do
    user = get_user(:native)
    user.password_digest = nil
    assert !user.save, "Created native user without password digest"
    assert_match(/be blank/, user.errors[:password_digest].first,
                 "No message about empty username - #{user.errors[:password_digest]}")
  end

  test "should create native without avatar" do
    user = get_user(:native)
    user.avatar = nil
    assert user.save, "Did not create native user without avatar"
  end

  test "should not save native with duplicate username" do
    user1 = get_user(:native)
    user2 = get_user(:native,4)
    user2.username = user1.username

    assert user1.save, "Did not save user with unique username"
    assert !user2.save, "Saved user with duplicate username"
    assert_match(/has already been taken/, user2.errors[:username].first,
                 "No message about duplicate username - #{user2.errors[:username]}")
  end

  test "should not save native with duplicate email" do
    user1 = get_user(:native)
    user2 = get_user(:native,4)
    user2.email = user1.email

    assert user1.save, "Did not save user with unique email"
    assert !user2.save, "Saved user with duplicate email"
    assert_match(/has already been taken/, user2.errors[:email].first,
                 "No message about duplicate email - #{user2.errors[:email]}")
  end

  #
  # For gplus accounts
  #
  test "should not create gplus without username" do
    user = get_user(:gplus)
    user.username = nil
    assert !user.save, "Created gplus user without username"
    assert_match(/be blank/, user.errors[:username].first,
                 "No message about empty username - #{user.errors[:username]}")
  end

  test "should not create gplus without email" do
    user = get_user(:gplus)
    user.email = nil
    assert !user.save, "Created gplus user without email"
    assert_match(/be blank/, user.errors[:email].first,
                 "No message about empty username - #{user.errors[:email]}")
  end

  test "should not create gplus without fullname" do
    user = get_user(:gplus)
    user.fullname = nil
    assert !user.save, "Created gplus user without full name"
    assert_match(/be blank/, user.errors[:fullname].first,
                 "No message about empty username - #{user.errors[:fullname]}")
  end

  test "should create gplus without avatar" do
    user = get_user(:gplus)
    user.avatar = nil
    assert user.save, "Did not create gplus user without avatar"
  end

  test "should not save gplus with duplicate gplus_id" do
    user1 = get_user(:gplus)
    user2 = get_user(:gplus,4)
    user2.gplus_id = user1.gplus_id

    assert user1.save, "Did not save user with unique gplus_id"
    assert !user2.save, "Saved user with duplicate gplus_id"
    assert_match(/has already been taken/, user2.errors[:gplus_id].first,
                 "No message about duplicate gplus_id - #{user2.errors[:gplus_id]}")
  end

  test "should not save gplus with duplicate username" do
    user1 = get_user(:gplus)
    user2 = get_user(:gplus,4)
    user2.username = user1.username

    assert user1.save, "Did not save user with unique username"
    assert !user2.save, "Saved user with duplicate username"
    assert_match(/has already been taken/, user2.errors[:username].first,
                 "No message about duplicate username - #{user2.errors[:username]}")
  end

  test "should not save gplus with duplicate email" do
    user1 = get_user(:gplus)
    user2 = get_user(:gplus,4)
    user2.email = user1.email

    assert user1.save, "Did not save user with unique email"
    assert !user2.save, "Saved user with duplicate email"
    assert_match(/has already been taken/, user2.errors[:email].first,
                 "No message about duplicate email - #{user2.errors[:email]}")
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
end
