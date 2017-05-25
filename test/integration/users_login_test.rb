require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'user login' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email:'', password: '' }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    log_in_as(@user)
    follow_redirect!
    assert_template 'reports/index'
  end
end
