require 'watir-webdriver'
require 'headless'
require 'test_helper'

class StaticPagesTest < ActionController::TestCase
  setup do
    #
    # Desktop mode
    #
    # TODO: Repeate for tablet and mobile modes
    #
    if ENV['HEADLESS']
      @headless = Headless.new
      @headless.start
    end
    @browser = Watir::Browser.new
    @browser.window.resize_to(1200, 900)
  end

  def teardown
    @browser.close
    # @headless.destory
  end

  def test_home_page_should_contain_expected_text
    @browser.goto '/'
    home_page_checks
  end

  def test_signup_button_should_redirect_to_signup_page
    @browser.goto '/'

    signup_button = @browser.a :class => 'btn btn-large btn-success'

    assert signup_button.exists?, "Signup button does not exist"
    assert_match(/Sign up today/, signup_button.text, "Wrong text on signup button")

    signup_button.click
  end

  def test_login_menu_should_redirect_to_login_page
    @browser.goto '/'

    login_menu = @browser.a :text => 'Log in'
    assert login_menu.exists?, "Login menu does not exist"
    login_menu.click

    assert_match(/login$/, @browser.url, "Login menu does not redirect to login page")

    login_page_checks
  end

  def test_home_menu_should_redirect_to_home_page
    @browser.goto '/signup'

    home_menu = @browser.a :text => 'Home'
    assert home_menu.exists?, "Home menu does not exist"
    home_menu.click

    assert_match(/home$/, @browser.url, "Home menu does not redirect to home page")
    home_page_checks
  end

  def test_title_link_should_redirect_to_home_page
    @browser.goto '/login'

    title_link = @browser.a :text => Settings.app_name

    assert title_link.exists?, "Home menu does not exist"

    title_link.click

    assert_match(/home$/, @browser.url, "Title link does not redirect to home page")

    home_page_checks
  end

  private

  def home_page_checks
    assert_match(/#{Settings.app_name}/, @browser.title)
    assert_match(/Log your work, or you did not do it!/, @browser.text,
                 "Does not contain proper text")
    assert_match(/Multiple contexts/, @browser.text,
                 "Does not contain proper text")
    assert_match(/Task management/, @browser.text,
                 "Does not contain proper text")
    assert_match(/With #{Settings.app_name}, it is easy to log your tasks/, @browser.text,
                 "Does not contain proper text")
  end

  def signup_page_checks
    assert_match(/signup$/, @browser.url, "Sign up button does not redirect to signup page")
  end

  def login_page_checks
    assert_match(/login$/, @browser.url, "Log in button does not redirect to signup page")
  end
end
