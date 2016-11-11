require 'test_helper'

class WitControllerTest < ActionController::TestCase
  test "should get test_poc" do
    get :test_poc
    assert_response :success
  end

end
