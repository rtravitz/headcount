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

    ep = EconomicProfile.new(data)

    assert_equal 50000, ep.median_household_income_in_year(2015)
    assert_raises(UnknownDataError) do
      ep.median_household_income_in_year(2000)
    end
  end

  def test_median_household_income_average
    ep = EconomicProfile.new(data)

    assert_equal 55000, ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    ep = EconomicProfile.new(data)

    assert_in_delta 0.184, ep.children_in_poverty_in_year(2012), 0.005
    assert_raises(UnknownDataError) do
      ep.children_in_poverty_in_year(2000)
    end
  end

  def test_children_in_poverty_average
    ep = EconomicProfile.new(data)

    assert_in_delta 0.159, ep.children_in_poverty_average, 0.005
  end

  def test_free_or_reduced_lunch_percentage_in_year
    ep = EconomicProfile.new(data)

    assert_in_delta 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014), 0.005
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    end
  end

  def test_free_or_reduced_lunch_number_in_year
    ep = EconomicProfile.new(data)

    assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
    assert_raises(UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(2000)
    end
  end

  def test_free_or_reduced_price_lunch_average
    ep = EconomicProfile.new(:free_or_reduced_price_lunch => {2014 => {:percent => 0.023, :total => 100}, 2015 => {percent: 0.123, total: 50}})

    assert_equal 0.073, ep.free_or_reduced_price_lunch_average, 0.005
  end

  def test_title_i_in_year
    ep = EconomicProfile.new(data)

    assert_in_delta 0.543, ep.title_i_in_year(2015), 0.005
    assert_raises(UnknownDataError) do
      ep.title_i_in_year(2000)
    end
  end

  def test_find_all_median_years
    ep = EconomicProfile.new(data)

    assert_equal [2013, 2014, 2015], ep.find_all_median_years.sort
  end

  def data
  { :median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845, 2013 => 0.1325},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}, 2015 => {percentage: 0.123, total: 50}},
    :title_i => {2015 => 0.543},
   }
  end

end
