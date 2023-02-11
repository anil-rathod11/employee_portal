require "test_helper"

class EmployeeControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get employee_login_url
    assert_response :success
  end
end
