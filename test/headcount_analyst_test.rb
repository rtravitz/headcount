require './test/test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
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

    assert_equal 0.766, action
  end

end
