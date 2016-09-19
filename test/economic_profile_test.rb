require './test/test_helper'
require './lib/economic_profile'
require './lib/economic_profile_repository'

class EconomicProfileTest < Minitest::Test

  def test_statewide_testing_can_have_name_and_data
    data = {:name => "Hello", :stuff => "More Stuff"}
    ep = EconomicProfile.new(data)

    assert_equal "Hello", ep.name
    assert_equal data, ep.information
  end

  def test_median_household_income_in_year
    data = {:median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000},
              :children_in_poverty => {2012 => 0.1845},
              :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
              :title_i => {2015 => 0.543},
             }
    ep = EconomicProfile.new(data)

    assert_equal 50000, ep.median_household_income_in_year(2015)
  end

end
