require "test_helper"

class BundlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bundles_index_url
    assert_response :success
  end
end
