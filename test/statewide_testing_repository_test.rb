require './test/test_helper'
require './lib/statewide_testing_repository'
require 'pry'

class StatewideTestingRepositoryTest < Minitest::Test

  def test_statewide_test_repository_exists
    str = StatewideTestingRepository.new

    assert_instance_of StatewideTestingRepository, str
  end

  def test_statewide_repo_makes_statewides_from_csv
    str = StatewideTestingRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })


    statewide = str.repository["COLORADO"]

    assert_instance_of StatewideTesting, statewide
    assert_equal "COLORADO", statewide.name
  end


end
