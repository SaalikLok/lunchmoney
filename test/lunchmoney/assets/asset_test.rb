# typed: strict
# frozen_string_literal: true

require "test_helper"

class AssetTest < ActiveSupport::TestCase
  test "type_name can be set to known valid types" do
    LunchMoney::Asset::VALID_TYPE_NAMES.each do |type_name|
      assert_nothing_raised do
        create_asset(type_name:)
      end
    end
  end

  test "type_name can not be set in an invalid type" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_asset(type_name: "invalid_type_name")
    end

    assert_match(/is invalid, must be one of/, error.message)
  end

  test "subtype_name can be set to known valid types" do
    LunchMoney::Asset::VALID_SUBTYPE_NAMES.each do |subtype_name|
      assert_nothing_raised do
        create_asset(subtype_name:)
      end
    end
  end

  test "subtype_name can not be set in an invalid type" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_asset(subtype_name: "invalid_subtype_name")
    end

    assert_match(/is invalid, must be one of/, error.message)
  end

  test "balance_as_of can be set to a valid timestamp" do
    assert_nothing_raised do
      create_asset(balance_as_of: "2023-01-01T01:01:01.000Z")
    end
  end

  test "balance_as_of can not be set to an invalid timestamp" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_asset(balance_as_of: "2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end

  test "created_at can be set to a valid timestamp" do
    assert_nothing_raised do
      create_asset(created_at: "2023-01-01T01:01:01.000Z")
    end
  end

  test "created_at can not be set to an invalid timestamp" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_asset(created_at: "2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end

  sig do
    params(
      type_name: String,
      subtype_name: String,
      balance_as_of: String,
      created_at: String,
    ).returns(LunchMoney::Asset)
  end
  def create_asset(type_name: "cash", subtype_name: "retirement", balance_as_of: "2023-01-01T01:01:01.000Z",
    created_at: "2023-01-01T01:01:01.000Z")
    LunchMoney::Asset.new(
      "id": 1,
      "type_name": type_name,
      "subtype_name": subtype_name,
      "name": "Test Asset 1",
      "balance": "1201.0100",
      "balance_as_of": balance_as_of,
      "currency": "cad",
      "institution_name": "Bank of Me",
      "exclude_transactions": false,
      "created_at": created_at,
    )
  end
end
