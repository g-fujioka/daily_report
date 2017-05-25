require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get new_report_path
    assert_response :success
  end

  test "report create" do
    get new_report_path
    assert_difference 'Report.count', 1 do
    post reports_path params: { report: { report_date: '2017-04-01',
                                          title: 'hello',
                                          content: 'hello',
                                          user_id: @user.id
                                        }}
    end
  assert_not flash.empty?
  assert_redirected_to reports_url
  end
end
