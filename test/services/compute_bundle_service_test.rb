require 'test_helper'

class ComputeBundleServiceTest < ActiveSupport::TestCase
  test 'should return correct constant variable values' do
    bundles = ComputeBundleService::BUNDLES

    assert(bundles[:img],  { 5 => 450, 10 => 800 })
    assert(bundles[:flac], { 3 => 427.50, 6 => 810, 9 => 1147.50 })
    assert(bundles[:vid],  { 3 => 570, 5 => 900, 9 => 1530 })
  end

  test 'should return correct computations' do
    result = ComputeBundleService.new(img: 10, flac: 15, vid: 13)

    sample_result = {
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

    assert(result, sample_result)
  end

  test 'should return error if minimum bundle not reached' do
  end

  test 'should return error if order is not a bundle' do
  end
end
