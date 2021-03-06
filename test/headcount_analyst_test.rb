require './test/test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
  end

  def test_headcount_analyst_exists
    ha = HeadcountAnalyst.new(@dr)

    assert_instance_of HeadcountAnalyst, ha
  end

  def test_kindergarten_participation_rate_variation
    ha = HeadcountAnalyst.new(@dr)
    action = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    action2 = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_equal 0.766, action
    assert_equal 0.447, action2
  end

  def test_kindergarten_participation_rate_variation_trend
    ha = HeadcountAnalyst.new(@dr)
    action = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    expected = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }

    assert_in_delta expected[2010], action[2010]
    assert_in_delta expected[2008], action[2008], 0.005
    assert_in_delta expected[2004], action[2004], 0.005
  end

  def test_graduation_variation
    ha = HeadcountAnalyst.new(@dr)
    action = ha.graduation_variation('ACADEMY 20', :against => 'COLORADO')
    action2 = ha.graduation_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')

    assert_equal 1.195, action
    assert_equal 1.011, action2
  end

  def test_kindergarten_participation_against_hs_graduation
    ha = HeadcountAnalyst.new(@dr)
    assert_in_delta 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J'), 0.005
    assert_in_delta 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2'), 0.005
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    ha = HeadcountAnalyst.new(@dr)
    action = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')

    assert action

    action2 = ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')

    refute action2

    action3 = ha.kindergarten_participation_correlates_with_high_school_graduation(
    :across => ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    )

    assert action3
  end

  def test_high_income_disparity
    ha = HeadcountAnalyst.new(@dr)

    set = ha.high_income_disparity

    assert_instance_of ResultSet, set
    assert_equal 2, set.matching_districts.count
    assert_equal "HINSDALE COUNTY RE 1", set.matching_districts.first.name
    assert_equal 63265.2, set.matching_districts.first.median_household_income
    assert_in_delta 0.205, set.matching_districts.first.children_in_poverty_rate, 0.005
    assert_instance_of ResultEntry, set.statewide_average
    assert_equal 57408.0, set.statewide_average.median_household_income
    assert_in_delta 0.165, set.statewide_average.children_in_poverty_rate, 0.005
  end

  def test_high_poverty_and_high_school_graduation
    ha = HeadcountAnalyst.new(@dr)

    set = ha.high_poverty_and_high_school_graduation

    assert_instance_of ResultSet, set
    assert_equal 55, set.matching_districts.count
    assert_instance_of ResultEntry, set.matching_districts.first
    assert_equal "ALAMOSA RE-11J", set.matching_districts.first.name
    assert_in_delta 0.637, set.matching_districts.first.free_or_reduced_price_lunch_rate, 0.005
    assert_in_delta 0.266, set.matching_districts.first.children_in_poverty_rate, 0.005
    assert_in_delta 0.759, set.matching_districts.first.high_school_graduation_rate, 0.005
    assert_in_delta 0.350, set.statewide_average.free_or_reduced_price_lunch_rate, 0.005
    assert_in_delta 0.164, set.statewide_average.children_in_poverty_rate, 0.005
    assert_in_delta 0.751, set.statewide_average.high_school_graduation_rate, 0.005
  end

  def test_kindergarten_participation_against_household_income
    ha = HeadcountAnalyst.new(@dr)

    action = ha.kindergarten_participation_against_household_income('ACADEMY 20')
    assert_in_delta 0.502, action, 0.005
  end

  def test_kindergarten_participation_correlates_with_household_income
    ha = HeadcountAnalyst.new(@dr)

    refute ha.kindergarten_participation_correlates_with_household_income(for: 'ACADEMY 20')
    assert ha.kindergarten_participation_correlates_with_household_income(for: 'COLORADO')
    refute ha.kindergarten_participation_correlates_with_household_income(for: 'STATEWIDE')
    refute ha.kindergarten_participation_correlates_with_household_income(:across => ['ACADEMY 20', 'YUMA SCHOOL DISTRICT 1', 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
  end


end
