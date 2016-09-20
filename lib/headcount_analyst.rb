require_relative 'district_repository'
require_relative 'result_entry'
require_relative 'result_set'

class HeadcountAnalyst

  def initialize(district_repository)
    @dr = district_repository
  end

  def kindergarten_participation_rate_variation(district, against)
    numerator = @dr.find_by_name(district.upcase).enrollment
    numerator = numerator.kindergarten_participation_by_year.values
    denominator = @dr.find_by_name(against[:against]).enrollment
    denominator = denominator.kindergarten_participation_by_year.values
    numerator_average = average(numerator)
    denominator_average = average(denominator)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    numerator = @dr.find_by_name(district.upcase).enrollment
    numerator = numerator.kindergarten_participation_by_year
    denominator = @dr.find_by_name(against[:against]).enrollment
    denominator = denominator.kindergarten_participation_by_year
    result = Hash.new
    numerator.each do |year, rate|
      result[year] = (rate / denominator[year]).round(3)
    end
    result
  end

  def average(array)
    array.reduce(0.0){|sum, item| sum + item} / array.length
  end

  def graduation_variation(district, against)
    numerator = @dr.find_by_name(district.upcase).enrollment
    denominator = @dr.find_by_name(against[:against]).enrollment
    numerator_average = average(numerator.graduation_rate_by_year.values)
    denominator_average = average(denominator.graduation_rate_by_year.values)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    numer = kindergarten_participation_rate_variation(name, against: "COLORADO")
    denominator = graduation_variation(name, against: "COLORADO")
    (numer / denominator).round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(command)
    return check_statewide               if statewide?(command)
    return check_one_district(command)   if one_district?(command)
    return check_multi_district(command) if multi_district?(command)
  end

  def high_income_disparity
    state_profile = @dr.find_economic_profile("COLORADO")
    co_median = state_profile.median_household_income_average
    co_poverty = state_profile.children_in_poverty_average
    matches = Array.new
    @dr.ecr.each do |profile|
      if profile.median_household_income_average > co_median &&
         profile.children_in_poverty_average > co_poverty
         matches << ResultEntry.new(profile.information)
      end
    end
  end

  def check_statewide
    values = @dr.dr.map do |name, district|
      item = kindergarten_participation_against_high_school_graduation(name)
      return_check(item)
    end
    grouped = values.group_by{|boolean| boolean}
    (grouped[true].count / values.count) >= 0.7 ? true : false
  end

  def check_one_district(command)
    c = command[:for]
    value = kindergarten_participation_against_high_school_graduation(c)
    return_check(value)
  end

  def check_multi_district(command)
    values = command[:across].map do |name|
      v = kindergarten_participation_against_high_school_graduation(name.upcase)
      return_check(v)
    end
    grouped = values.group_by{|boolean| boolean}
    (grouped[true].count / values.count) >= 0.7 ? true : false
  end

  def statewide?(command)
    command.has_value?('STATEWIDE')
  end

  def one_district?(command)
    command.has_key?(:for) && !command.has_value?('STATEWIDE')
  end

  def multi_district?(command)
    !command.has_key?(:for) && !command.has_value?('STATEWIDE')
  end

  def return_check(value)
    return true if value <= 1.5 && value >= 0.6
    return false
  end
end
