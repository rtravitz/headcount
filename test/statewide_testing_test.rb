require './test/test_helper'
require './lib/statewide_testing'
require './lib/statewide_testing_repository'

class StatewideTestingTest < Minitest::Test

  def test_statewide_testing_can_have_name_and_data
    data = {:name => "Hello", :stuff => "More Stuff"}
    st = StatewideTesting.new(data)

    assert_equal "Hello", st.name
    assert_equal data, st.information
  end

  # def test_proficient_by_grade
  #   str = StatewideTestingRepository.new
  #   str.
  # end

end
