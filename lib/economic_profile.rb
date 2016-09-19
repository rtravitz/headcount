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



end
