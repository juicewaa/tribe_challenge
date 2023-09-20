require 'test_helper'

class ComputeBundleServiceTest < ActiveSupport::TestCase
  test 'should return correct constant variable values' do
    bundles = ComputeBundleService::BUNDLES

    assert_equal({ 5 => 450, 10 => 800 }, bundles[:img])
    assert_equal({ 3 => 427.50, 6 => 810, 9 => 1147.50 }, bundles[:flac])
    assert_equal({ 3 => 570, 5 => 900, 9 => 1530 }, bundles[:vid])
  end

  test 'should return correct computations' do
    result = ComputeBundleService.new(img: 10, flac: 15, vid: 13).call

    expected_result = {
      img: {
        total: 800,
        breakdown: [[1, 10]],
      },
      flac: {
        total: 1957.50,
        breakdown: [[1, 9], [1, 6]],
      },
      vid: {
        total: 2370,
        breakdown: [[2, 5], [1, 3]],
      },
    }

    assert_equal(expected_result, result)
  end

  test 'should return error message if minimum bundle not reached' do
  end

  test 'should return error message if order is not a bundle' do
  end
end
