# typed: strict
# frozen_string_literal: true

require "test_helper"

class AssetCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include VcrHelper

  test "assets returns an array of Asset objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("assets/assets_success") do
        api_call = LunchMoney::AssetCalls.new.assets

        api_call.each do |asset|
          assert_kind_of(LunchMoney::Asset, asset)
        end
      end
    end
  end

  test "assets returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::AssetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::AssetCalls.new.assets

    assert_kind_of(LunchMoney::Error, api_call.first)
  end
end
