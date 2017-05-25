require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:michael)
    @other = users(:archer)
  end

  test "login_user" do
    get login_path
    assert_template 'sessions/new'
    log_in_as(@admin_user)
    assert_redirected_to home_url
  end

end
