require "test_helper"

class StripePaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_payments_create_url
    assert_response :success
  end
end
