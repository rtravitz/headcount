require './test/test_helper'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_economic_profile_repository_exists
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

  def test_economic_profile_repository_makes_economic_profiles_from_csv
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./test/fixtures/Median household income.csv",
        :children_in_poverty => "./test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./test/fixtures/Title I students.csv"
      }
    })

    profile = epr.repository["COLORADO"]

    assert_instance_of EconomicProfile, profile
    assert_equal "COLORADO", profile.name
  end

  def test_economic_repository_find_by_name
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./test/fixtures/Median household income.csv",
        :children_in_poverty => "./test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./test/fixtures/Title I students.csv"
      }
    })

    ep = epr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", ep.name
    assert_instance_of EconomicProfile, ep
  end

end
