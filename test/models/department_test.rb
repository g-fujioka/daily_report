require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase

  def setup
    @department = Department.new(department_name: 'dept')
  end

  test 'department_name presence' do
    @department.department_name = ''
    assert_not @department.valid?
  end

end
