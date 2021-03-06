require_relative 'organizer'
require_relative 'sanitizer'

class EconomicProfile

  include Organizer
  include Sanitizer

  attr_reader :name, :information

  def initialize(data)
    @name = data[:name]
    @information = data
  end

  def median_household_income_in_year(year)
    Sanitizer.error?(find_all_median_years.include?(year))
    values = Array.new
    @information[:median_household_income].each do |years, value|
      values << value if (years.first..years.last).to_a.include?(year)
    end
    values.reduce(:+) / values.count
  end

  def median_household_income_average
    sum = @information[:median_household_income].values.reduce(:+)
    sum / @information[:median_household_income].count
  end

  def children_in_poverty_in_year(year)
    Sanitizer.error?(@information[:children_in_poverty].has_key?(year))
    @information[:children_in_poverty][year]
  end

  def children_in_poverty_average
    sum = @information[:children_in_poverty].values.reduce(:+)
    sum / @information[:children_in_poverty].count
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    Sanitizer.error?(@information[:free_or_reduced_price_lunch].has_key?(year))
    @information[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    Sanitizer.error?(@information[:free_or_reduced_price_lunch].has_key?(year))
    @information[:free_or_reduced_price_lunch][year][:total]
  end

  def free_or_reduced_price_lunch_average
    sum = @information[:free_or_reduced_price_lunch].map do |year, data|
      data[:percent]
    end
    sum.reduce(:+) / sum.count
  end

  def title_i_in_year(year)
    Sanitizer.error?(@information[:title_i].has_key?(year))
    @information[:title_i][year]
  end

  def find_all_median_years
    @information[:median_household_income].map do |years, value|
      (years.first..years.last).to_a
    end.flatten.uniq
  end

end
