require './test/test_helper'
require './lib/district'
require './lib/district_repository'

class DistrictTest < Minitest::Test

  def test_district_exists
    d = District.new({:name => 'Test Name'}, "")

    assert_instance_of District, d
  end

  def test_district_has_a_name_from_a_hash
    d = District.new({:name => 'ACADEMY 20'}, "")

    assert_equal "ACADEMY 20", d.name
  end

  def test_district_can_access_enrollment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    district.enrollment
  end

  def test_district_can_find_its_enrollment
    dr = DistrictRepository.new
    dr.load_data(paths)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
    assert_equal "ACADEMY 20", district.enrollment.name
  end

  def test_district_can_find_its_statewide
    dr = DistrictRepository.new
    dr.load_data(paths)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of StatewideTest, district.statewide_test
    assert_equal "ACADEMY 20", district.statewide_test.name

  end

  def test_district_can_find_its_economic_profile
    dr = DistrictRepository.new
    dr.load_data(paths)
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of EconomicProfile, district.economic_profile
    assert_equal "ACADEMY 20", district.economic_profile.name
  end

  def paths
    {
      :enrollment => {
        :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv",
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/Median household income.csv",
        :children_in_poverty => "./test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./test/fixtures/Title I students.csv"
      }
    }
  end

end
