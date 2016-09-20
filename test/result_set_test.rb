require './lib/result_set'
require './lib/result_entry'
require './test/test_helper'

class ResultSetTest < Minitest::Test

  def test_result_set_takes_multiple_results
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    children_in_poverty_rate: 0.25,
    high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    children_in_poverty_rate: 0.2,
    high_school_graduation_rate: 0.6})
    rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)

    assert_equal 0.5, rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.25, rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.75, rs.matching_districts.first.high_school_graduation_rate

    assert_equal 0.3, rs.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.2, rs.statewide_average.children_in_poverty_rate
    assert_equal 0.6, rs.statewide_average.high_school_graduation_rate
  end


end
