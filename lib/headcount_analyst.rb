require_relative './district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district, against)
    numerator = @district_repository.find_by_name(district.upcase).enrollment
    denominator = @district_repository.find_by_name(against[:against]).enrollment
    numerator_average = average(numerator.kindergarten_participation_by_year.values)
    denominator_average = average(denominator.kindergarten_participation_by_year.values)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    numerator = @district_repository.find_by_name(district.upcase).enrollment.kindergarten_participation_by_year
    denominator = @district_repository.find_by_name(against[:against]).enrollment.kindergarten_participation_by_year
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
    numerator = @district_repository.find_by_name(district.upcase).enrollment
    denominator = @district_repository.find_by_name(against[:against]).enrollment
    numerator_average = average(numerator.graduation_rate_by_year.values)
    denominator_average = average(denominator.graduation_rate_by_year.values)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    numerator = kindergarten_participation_rate_variation(name, against: "COLORADO")
    denominator = graduation_variation(name, against: "COLORADO")
    (numerator / denominator).round(3)
  end
end
