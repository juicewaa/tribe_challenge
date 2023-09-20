require 'test_helper'

class ComputeBundleServiceTest < ActiveSupport::TestCase
  test 'should return correct constant variable values' do
    bundles = ComputeBundleService::BUNDLES

    assert_equal({ name: 'Image', prices: { 5 => 450, 10 => 800 }}, bundles[:img])
    assert_equal({ name: 'Audio', prices: { 3 => 427.50, 6 => 810, 9 => 1147.50 }}, bundles[:flac])
    assert_equal({ name: 'Video', prices: { 3 => 570, 5 => 900, 9 => 1530 }}, bundles[:vid])
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
    result = ComputeBundleService.new(img: 20, flac: 0, vid: 1).call

    assert_equal({ total: 1600, breakdown: [[2, 10]] }, result[:img])
    assert_equal({ msg: "Minimum order for Audio bundle is 3." }, result[:flac])
    assert_equal({ msg: "Minimum order for Video bundle is 3." }, result[:vid])
  end

  test 'should return error message if order is not a bundle' do
    result = ComputeBundleService.new(img: 11, flac: 13, vid: 25).call

    assert_equal({ msg: 'Number of Image order can`t be bundled.' }, result[:img])
    assert_equal({ msg: 'Number of Audio order can`t be bundled.' }, result[:flac])
    assert_equal({ total: 4500, breakdown: [[5, 5]] }, result[:vid])
  end
end
