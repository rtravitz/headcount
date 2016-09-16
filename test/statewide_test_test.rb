require './test/test_helper'
require './lib/statewide_test'
require './lib/statewide_testing_repository'

class StatewideTestTest < Minitest::Test

  def test_statewide_testing_can_have_name_and_data
    data = {:name => "Hello", :stuff => "More Stuff"}
    st = StatewideTest.new(data)

    assert_equal "Hello", st.name
    assert_equal data, st.information
  end

  def test_proficient_by_grade
    str = StatewideTestingRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    expected = {  2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                  2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                  2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                  2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                  2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                  2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                  2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
                }

    district = str.find_by_name("ACADEMY 20")

    assert_in_delta expected[2008][:math], district.proficient_by_grade(3)[2008][:math], 0.005
    assert_in_delta expected[2013][:reading], district.proficient_by_grade(3)[2013][:reading], 0.005
  end

end
