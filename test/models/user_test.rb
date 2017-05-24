require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @department_id = departments(:one).id
    @user = User.new(name: "Example User", email: "user@example.com",
        password: "foobar", password_confirmation: "foobar", department_id: @department_id)
  end

  test "user valid?" do
    assert @user.valid?
  end
end
