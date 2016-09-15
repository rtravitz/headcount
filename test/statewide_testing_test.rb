require './test/test_helper'
require './lib/statewide_testing'

class StatewideTestingTest < Minitest::Test

  def test_statewide_testing_can_have_name
    data = {:name => "Hello", :stuff => "More Stuff"}
    st = StatewideTesting.new(data)

    assert_equal "Hello", st.name
    assert_equal data, st.information
  end

end
