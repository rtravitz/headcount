require './test/test_helper'
require './lib/sanitizer'

class SanitizerTest < Minitest::Test
  include Sanitizer

  def test_check_type_returns_proper_type
    assert_equal :enrollment, Sanitizer.check_type(:kindergarten)
    assert_equal :enrollment, Sanitizer.check_type(:high_school_graduation)
    assert_equal :grades, Sanitizer.check_type(:third_grade)
    assert_equal :grades, Sanitizer.check_type(:eighth_grade)
    assert_equal :testing, Sanitizer.check_type(:math)
    assert_equal :testing, Sanitizer.check_type(:reading)
    assert_equal :testing, Sanitizer.check_type(:writing)
    assert_equal :median, Sanitizer.check_type(:median_household_income)
    assert_equal :poverty_lunch, Sanitizer.check_type(:children_in_poverty)
    assert_equal :poverty_lunch, Sanitizer.check_type(:free_or_reduced_price_lunch)
    assert_equal :title_i, Sanitizer.check_type(:title_i)
  end

  def test_standard_clean
    fake_data = {location: "Colorado", timeframe: "2005", data: "0.23579"}
    cleaned_data = Sanitizer.standard_clean(fake_data)

    assert_equal "COLORADO", cleaned_data[:location]
    assert_equal 2005, cleaned_data[:timeframe]
    assert_equal 0.236, cleaned_data[:data]
  end

  def test_clean_median_income
    fake_data = {location: "Colorado", data: "8675309"}
    cleaned_data = Sanitizer.clean_median_income(fake_data)

    assert_equal "COLORADO", cleaned_data[:location]
    assert_equal 8675309, cleaned_data[:data]
  end

  def test_poverty_lunch
    fake_data1 = {location: "Colorado", timeframe: "1942", dataformat: "Percent", data: "0.94832"}
    fake_data2 = {location: "Colorado", timeframe: "1942", dataformat: "Number", data: "15896"}
    cleaned_data1 = Sanitizer.clean_poverty_and_lunch(fake_data1)
    cleaned_data2 = Sanitizer.clean_poverty_and_lunch(fake_data2)

    assert_equal "COLORADO", cleaned_data1[:location]
    assert_equal 1942, cleaned_data1[:timeframe]
    assert_equal 15896, cleaned_data2[:data]
    assert_equal 0.948, cleaned_data1[:data]
  end

end
