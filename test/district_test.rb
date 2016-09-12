require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_exists
    d = District.new({:name => 'Test Name'})

    assert_instance_of District, d
  end

  def test_district_has_a_name_from_a_hash
    d = District.new({:name => 'ACADEMY 20'})

    assert_equal "ACADEMY 20", d.name
  end

end
