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

  def kindergarten_participation_against_household_income(input)
    state = {against: "COLORADO"}
    kinder = kindergarten_participation_rate_variation(input, state)
    income = median_income_variation(input, state)
    (kinder / income).round(3)
  end

  def kindergarten_participation_correlates_with_household_income(input)
    return one_district_correlation(input)  if one_district?(input)
    return statewide_correlation            if statewide?(input)
    return across_correlation(input)        if input.has_key?(:across)
  end

  def high_income_disparity
    state_profile = @dr.find_economic_profile("COLORADO")
    co_median = state_profile.median_household_income_average
    co_poverty = find_state_poverty_average
    state_average = ResultEntry.new({median_household_income: co_median,
      children_in_poverty: co_poverty})
    matches = Array.new
    @dr.ecr.repository.each do |name, profile|
      if (profile.median_household_income_average > co_median &&
         profile.children_in_poverty_average > co_poverty)
         matches << create_income_disparity_entry(profile)
      end
    end
    ResultSet.new(matching_districts: matches, statewide_average: state_average)
  end

  def high_poverty_and_high_school_graduation
    co_lunch = find_state_lunch_average
    co_poverty = find_state_poverty_average
    co_graduation = find_average_high_school_graduation
    state_average = ResultEntry.new({free_or_reduced_price_lunch: co_lunch,
                                    children_in_poverty: co_poverty,
                                    high_school_graduation: co_graduation})
    matches = Array.new
    @dr.dr.each do |name, district|
      check = meets_poverty_and_high_school_threshold?( district, co_lunch,
                                            co_poverty, co_graduation)
      if check
        matches << create_high_poverty_entry(district)
      end
    end
    ResultSet.new(matching_districts: matches, statewide_average: state_average)
  end


  private

  def across_correlation(input)
    collected = input[:across].map do |name|
      correlates?(kindergarten_participation_against_household_income(name))
    end
    grouped = collected.group_by{|boolean| boolean}
    if grouped[true].nil?
      false
    else
      (grouped[true].count.to_f / collected.count) >= 0.7 ? true : false
    end
  end

  def average(array)
    array.reduce(0.0){|sum, item| sum + item} / array.length
  end

  def check_multi_district(command)
    values = command[:across].map do |name|
      v = kindergarten_participation_against_high_school_graduation(name.upcase)
      return_check(v)
    end
    grouped = values.group_by{|boolean| boolean}
    (grouped[true].count / values.count) >= 0.7 ? true : false
  end

  def check_one_district(command)
    c = command[:for]
    value = kindergarten_participation_against_high_school_graduation(c)
    return_check(value)
  end

  def check_statewide
    values = @dr.dr.map do |name, district|
      item = kindergarten_participation_against_high_school_graduation(name)
      return_check(item)
    end
    grouped = values.group_by{|boolean| boolean}
    (grouped[true].count / values.count) >= 0.7 ? true : false
  end

  def correlates?(num)
    num >= 0.6 && num <= 1.5 ? true : false
  end

  def create_income_disparity_entry(profile)
    ResultEntry.new(
            { name: profile.name,
              median_household_income: profile.median_household_income_average,
              children_in_poverty: profile.children_in_poverty_average}
      )
  end

  def create_high_poverty_entry(district)
    lunch = district.economic_profile.free_or_reduced_price_lunch_average
    poverty = district.economic_profile.children_in_poverty_average
    graduation = district.enrollment.graduation_rate_average
    ResultEntry.new(
    {name: district.name,
      free_or_reduced_price_lunch: lunch,
      children_in_poverty: poverty,
      high_school_graduation: graduation}
      )
  end

  def find_average_high_school_graduation
    state = @dr.find_enrollment("COLORADO")
    sum = state.information[:high_school_graduation].map{|year, rate| rate}
    sum.reduce(:+) / sum.count
  end

  def find_state_lunch_average
    state = @dr.find_economic_profile("COLORADO")
    sum = state.information[:free_or_reduced_price_lunch].map do |year, data|
      data[:percent]
    end
    sum.reduce(:+) / sum.count
  end

  def find_state_poverty_average
    averages = @dr.ecr.repository.map do |name, profile|
      unless profile.information[:children_in_poverty].nil?
        profile.children_in_poverty_average
      end
    end.compact
    averages.reduce(:+) / averages.count
  end

  def median_income_variation(district, against)
    numerator = @dr.find_economic_profile(district.upcase)
    numerator = numerator.median_household_income_average
    denominator = @dr.find_economic_profile(against[:against])
    denominator = denominator.median_household_income_average
    (numerator / denominator).round(3)
  end

  def meets_poverty_and_high_school_threshold?(district, lunch, poverty, grad)
    if (district.economic_profile.free_or_reduced_price_lunch_average > lunch &&
      district.economic_profile.children_in_poverty_average > poverty &&
      district.enrollment.graduation_rate_average > grad)
      return true
    else
      return false
    end
  end

  def multi_district?(command)
    !command.has_key?(:for) && !command.has_value?('STATEWIDE')
  end

  def one_district?(command)
    command.has_key?(:for) && !command.has_value?('STATEWIDE')
  end

  def one_district_correlation(input)
    num = (kindergarten_participation_against_household_income(input[:for]))
    correlates?(num)
  end

  def return_check(value)
    return true if value <= 1.5 && value >= 0.6
    return false
  end

  def statewide?(command)
    command.has_value?('STATEWIDE')
  end

  def statewide_correlation
    collected = @dr.dr.map do |name, district|
      correlates?(kindergarten_participation_against_household_income(name))
    end
    grouped = collected.group_by{|boolean| boolean}
    return (grouped[true].count.to_f / collected.count) >= 0.7 ? true : false
  end

end
