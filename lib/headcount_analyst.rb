require './lib/district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district, against)
    numerator = @district_repository.find_by_name(district.upcase)
    denominator = @district_repository.find_by_name(against[:against])
    numerator_average = average(numerator.enrollment.kindergarten_participation.values)
    denominator_average = average(denominator.enrollment.kindergarten_participation.values)
    (numerator_average / denominator_average).to_s[0..4].to_f
  end

  def average(array)
    array.reduce(0.0){|sum, item| sum + item} / array.length
  end

end
