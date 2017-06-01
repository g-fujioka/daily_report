require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase

  def setup
    @department = Department.new(name: 'dept')
  end

  test 'department_name presence' do
    @department.name = ''
    assert_not @department.valid?
  end

end
