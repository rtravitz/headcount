require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_statewide_test_repository_exists
    str = StatewideTestRepository.new

    assert_instance_of StatewideTestRepository, str
  end

  def test_statewide_repo_makes_statewides_from_csv
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })


    statewide = str.repository["COLORADO"]

    assert_instance_of StatewideTest, statewide
    assert_equal "COLORADO", statewide.name
  end

  def test_statewide_repository_find_by_name
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    statewide = str.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", statewide.name
    assert_instance_of StatewideTest, statewide
  end
end
