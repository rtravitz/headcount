require_relative './district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @dr = district_repository
  end

  def kindergarten_participation_rate_variation(district, against)
    numerator = @dr.find_by_name(district.upcase).enrollment
    denominator = @dr.find_by_name(against[:against]).enrollment
    numerator_average = average(numerator.kindergarten_participation_by_year.values)
    denominator_average = average(denominator.kindergarten_participation_by_year.values)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    numerator = @dr.find_by_name(district.upcase).enrollment.kindergarten_participation_by_year
    denominator = @dr.find_by_name(against[:against]).enrollment.kindergarten_participation_by_year
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
    numerator = kindergarten_participation_rate_variation(name, against: "COLORADO")
    denominator = graduation_variation(name, against: "COLORADO")
    (numerator / denominator).round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(command)
    return check_statewide               if statewide?(command)
    return check_one_district(command)   if one_district?(command)
    return check_multi_district(command) if multi_district?(command)
  end

  def check_statewide
    values = @dr.repository.map do |name, district|
      return_check(kindergarten_participation_against_high_school_graduation(name))
    end
    grouped = values.group_by{|boolean| boolean}
    (grouped[true].count / values.count) >= 0.7 ? true : false
  end

  def check_one_district(command)
    value = kindergarten_participation_against_high_school_graduation(command[:for])
    return_check(value)
  end

  def check_multi_district(command)
    values = command[:across].map do |name|
      return_check(kindergarten_participation_against_high_school_graduation(name.upcase))
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
