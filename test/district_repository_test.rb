require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_district_repository_exists
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_class_starts_with_empty_repository
    dr = DistrictRepository.new

    assert dr.dr.empty?
    assert_instance_of Hash, dr.dr
  end

  def test_load_data_creates_hash_of_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
      }
    })
    dr.dr.each do |name, district|
      assert_instance_of District, district
    end
  end

  def test_load_data_creates_associated_enrollment_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
      }
    })

    district = dr.find_by_name("ACADEMY 20")
    action = district.enrollment.kindergarten_participation_in_year(2010)
    assert_equal 0.436, action
  end

  def test_district_repo_loads_multiple_datasets
    dr = DistrictRepository.new
    dr.load_data(paths)

    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
    assert_instance_of StatewideTest, district.statewide_test
    assert_instance_of EconomicProfile, district.economic_profile
  end

  def test_find_by_name_returns_correct_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
      }
      })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.name
  end

  def test_can_find_all_matching_names_in_district_hash
   dr = DistrictRepository.new
   dr.load_data({
    :enrollment => {
     :kindergarten => "./data/Kindergartners in full-day program.csv"
     }
     })
   district = dr.find_all_matching("Adam")
   assert_equal 2, district.count
   assert_equal [], dr.find_all_matching("blahhdhdhfd")
  end

  def test_district_repository_can_find_enrollment
    dr = DistrictRepository.new
    dr.load_data(paths)

    enrollment = dr.find_enrollment("ACADEMY 20")

    assert_equal "ACADEMY 20", enrollment.name
    assert_instance_of Enrollment, enrollment
  end

  def test_district_repository_can_find_statewide
    dr = DistrictRepository.new
    dr.load_data(paths)

    statewide = dr.find_statewide_test("ACADEMY 20")

    assert_equal "ACADEMY 20", statewide.name
    assert_instance_of StatewideTest, statewide
  end

  def test_district_repository_can_find_economic
    dr = DistrictRepository.new
    dr.load_data(paths)

    economic = dr.find_economic_profile("ACADEMY 20")

    assert_equal "ACADEMY 20", economic.name
    assert_instance_of EconomicProfile, economic
  end

  def test_location_exists
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv",
        :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
      }})

    assert dr.location_exists?("ACADEMY 20")
    refute dr.location_exists?("Timbuktu")
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
