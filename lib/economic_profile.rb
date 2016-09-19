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
    @information[:children_in_poverty][year].round(3)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    @information[:free_or_reduced_price_lunch][year][:percentage].round(3)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    @information[:free_or_reduced_price_lunch][year][:total].round(3)
  end

  def title_i_in_year(year)
    @information[:title_i][year].round(3)
  end

end
