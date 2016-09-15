require './test/test_helper'
require './lib/enrollment'
require './lib/enrollment_repository'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_instance_of Enrollment, e
  end

  def test_enrollment_takes_a_hash_of_data
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", e.name
  end

  def test_kindergarten_participation_by_year_truncates_floats_to_three
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.391, e.kindergarten_participation_by_year[2010]
    assert_equal 0.353, e.kindergarten_participation_by_year[2011]
    assert_equal 0.267, e.kindergarten_participation_by_year[2012]
  end

  def test_kindergarten_participation_in_year_returns_correct_truncated_number
    e = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal nil, e.kindergarten_participation_in_year(2000)
    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
    assert_equal 0.353, e.kindergarten_participation_in_year(2011)
    assert_equal 0.267, e.kindergarten_participation_in_year(2012)
  end

  def test_graduation_rate_by_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    action = enrollment.graduation_rate_by_year

    assert_in_delta 0.895, action[2011], 0.005
    assert_in_delta 0.913, action[2013], 0.005
    assert_in_delta 0.898, action[2014], 0.005
  end

  def test_graduation_rate_in_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")

    assert_equal nil, enrollment.graduation_rate_in_year(2000)
    assert_in_delta 0.895, enrollment.graduation_rate_in_year(2010), 0.005
    assert_in_delta 0.895, enrollment.graduation_rate_in_year(2011), 0.005
    assert_in_delta 0.889, enrollment.graduation_rate_in_year(2012), 0.005
  end
end
