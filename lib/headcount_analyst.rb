require_relative './district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district, against)
    numerator = @district_repository.find_by_name(district.upcase).enrollment
    denominator = @district_repository.find_by_name(against[:against]).enrollment
    numerator_average = average(numerator.kindergarten_participation.values)
    denominator_average = average(denominator.kindergarten_participation.values)
    (numerator_average / denominator_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, against)
    numerator = @district_repository.find_by_name(district.upcase).enrollment.kindergarten_participation
    denominator = @district_repository.find_by_name(against[:against]).enrollment.kindergarten_participation
    result = Hash.new
    numerator.each do |year, rate|
      result[year] = (rate / denominator[year]).round(3)
    end
    result
  end

  def average(array)
    array.reduce(0.0){|sum, item| sum + item} / array.length
  end


end
