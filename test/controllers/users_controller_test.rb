require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'user profile update' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              department_id: @user.department_id}}

    assert_not flash.empty?
    assert_redirected_to @user
  end

  test 'user create' do
    get new_user_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         department_id: 1,
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
   assert_not flash.empty?
   assert_redirected_to users_url
  end

  test 'user destroy' do
    get users_path
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to users_url
  end
end
