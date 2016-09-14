require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
    @e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_enrollment_exists
    assert_instance_of Enrollment, @e
  end

  def test_enrollment_takes_a_hash_of_data
    assert_equal "ACADEMY 20", @e.name
  end

  def test_kindergarten_participation_by_year_truncates_floats_to_three
    assert_equal 0.391, @e.kindergarten_participation_by_year[2010]
    assert_equal 0.353, @e.kindergarten_participation_by_year[2011]
    assert_equal 0.267, @e.kindergarten_participation_by_year[2012]
  end

  def test_kindergarten_participation_in_year_returns_correct_truncated_number
    assert_equal nil, @e.kindergarten_participation_in_year(2000)
    assert_equal 0.391, @e.kindergarten_participation_in_year(2010)
    assert_equal 0.353, @e.kindergarten_participation_in_year(2011)
    assert_equal 0.267, @e.kindergarten_participation_in_year(2012)
  end
end
