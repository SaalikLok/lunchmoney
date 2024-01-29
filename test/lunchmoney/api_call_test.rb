# typed: strict
# frozen_string_literal: true

require "test_helper"

class ApiCallTest < ActiveSupport::TestCase
  include Mocha::Typed
  include MockResponseHelper

  test "errors returns and empty array if no errors are present" do
    response = mock_faraday_response({})

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    assert_empty(errors)
  end

  test "errors returns errors when single error is returned" do
    error_message = "This is an error"
    response = mock_faraday_response({ error: error_message })

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    refute_empty(errors)

    assert_equal(error_message, errors.first.message)
  end

  test "errors returns errors when multiple errors are returned" do
    error_messages = ["This is an error", "This is another error"]
    response = mock_faraday_response({ error: error_messages })

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    refute_empty(errors)

    errors.each do |error|
      assert_includes(error_messages, error.message)
    end
  end

  test "clean_params removes params with nil values from hash" do
    test_params = {
      param_with_value: "param_with_value",
      other_param_with_value: "other_param_with_value",
      param_without_value: nil,
      other_param_without_value: nil,
    }

    cleaned_params = LunchMoney::ApiCall.new.send(:clean_params, test_params)

    assert_equal(2, cleaned_params.keys.count)
  end

  test "get does not send query params when empty" do
    response = mock_faraday_response({})
    endpoint = LunchMoney::ApiCall::BASE_URL + "me"

    Faraday::Connection.any_instance.expects(:get).with(endpoint).returns(response).once
    Faraday::Connection.any_instance.expects(:get).with(endpoint, {}).returns(response).never

    LunchMoney::ApiCall.new.send(:get, "me", query_params: {})
  end
end
