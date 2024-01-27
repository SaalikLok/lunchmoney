# typed: strict
# frozen_string_literal: true

require "test_helper"

class TagCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include FakeResponseDataHelper

  test "tags returns an array of Tag objects on success response" do
    VCR.use_cassette("tags/tags_success") do
      ensure_correct_api_key
      api_call = LunchMoney::TagCalls.new.tags

      api_call.each do |tag|
        assert_kind_of(LunchMoney::Tag, tag)
      end
    end
  end

  test "tags returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)
    LunchMoney::TagCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::TagCalls.new.tags

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end
end