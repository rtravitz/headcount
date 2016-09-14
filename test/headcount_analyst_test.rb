require './test/test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
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

    assert_in_delta expected[2010], action[2010], 0.005
    assert_in_delta expected[2008], action[2008], 0.005
    assert_in_delta expected[2004], action[2004], 0.005 
  end

end