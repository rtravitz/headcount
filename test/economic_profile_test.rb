require './test/test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def test_statewide_testing_can_have_name_and_data
    data = {:name => "Hello", :stuff => "More Stuff"}
    ep = EconomicProfile.new(data)

    assert_equal "Hello", ep.name
    assert_equal data, ep.information
  end

end
