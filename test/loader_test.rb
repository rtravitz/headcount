require './lib/loader'
require './test/test_helper'

class LoaderTest < Minitest::Test
  include Loader

  def test_check_repo_type
    assert_equal :enrollment, Loader.check_repo_type({:enrollment => 1})
    assert_equal :statewide_testing, Loader.check_repo_type({:statewide_testing => 1})
    assert_equal :economic_profile, Loader.check_repo_type({:economic_profile => 1})
  end

  def test_extract_paths
    expected = {
                  :enrollment => {:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}},
                  :statewide => {:statewide_testing => {:third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"}},
                  :economic => nil
                }

    assert_equal expected, Loader.extract_paths(paths)
  end

  def test_get_all_data_combines_data_from_multiple_files
    path = {:enrollment => {
              :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv",
              :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
            }}

    data = Loader.get_all_data(path)
    by_file = data.group_by{|row| row[:source]}

    assert by_file.has_key?(:kindergarten)
    assert by_file.has_key?(:high_school_graduation)
    assert_equal 22, by_file[:kindergarten].count
    assert_equal 10, by_file[:high_school_graduation].count
  end

  def test_group_data_orders_data_by_location
    path = {:enrollment => {
      :kindergarten => "./test/fixtures/Kindergartners in full-day program.csv",
      :high_school_graduation => "./test/fixtures/High school graduation rates.csv",
      }}

    data = Loader.get_all_data(path)
    grouped = Loader.group_data(data)

    assert grouped.has_key?("ACADEMY 20")
  end

  def paths
    {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
    }
  end

end
