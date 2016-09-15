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

end
