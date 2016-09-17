require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_district_repository_exists
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_class_starts_with_empty_repository
    dr = DistrictRepository.new

    assert dr.repository.empty?
    assert_instance_of Hash, dr.repository
  end

  def test_load_data_creates_hash_of_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv"
      }
    })
    dr.repository.each do |name, district|
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

  def test_district_repo_loads_multiple_datasets
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
    assert_instance_of StatewideTest, district.statewide_test
  end


end
