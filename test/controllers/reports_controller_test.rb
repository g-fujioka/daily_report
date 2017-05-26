require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
  end

  test "report create and destroy" do
    log_in_as(@user)
    get new_report_path
    assert_difference 'Report.count', 1 do
    post reports_path params: { report: { report_date: '2017-04-01',
                                          title: 'hello',
                                          content: 'hello',
                                          user_id: @user.id
                                        }}
    end
    report = assigns(:report)
    assert_not flash.empty?
    assert_redirected_to report
    assert_difference 'Report.count', -1 do
      delete report_path(report)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end