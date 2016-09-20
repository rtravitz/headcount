require './lib/result_entry'
require './test/test_helper'

class ResultEntryTest < Minitest::Test

  def test_result_entry_can_take_data
    re = ResultEntry.new({free_or_reduced_price_lunch: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})

    assert_equal 0.5, re.free_or_reduced_price_lunch_rate
    assert_equal nil, re.median_household_income
  end

end
