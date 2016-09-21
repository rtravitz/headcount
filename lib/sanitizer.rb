require_relative 'errors'

module Sanitizer

  def self.error?(condition)
    raise UnknownDataError unless condition
  end

  def self.sanitize(row)
    type = check_type(row[:source])
    return clean_enrollment_data(row)    if type == :enrollment
    return clean_grades(row)             if type == :grades
    return clean_testing(row)            if type == :testing
    return clean_median_income(row)      if type == :median
    return clean_poverty_and_lunch(row)  if type == :poverty_lunch
    return clean_title_i(row)            if type == :title_i
  end

  def self.check_type(row_source)
    return :enrollment if row_source == :kindergarten || row_source == :high_school_graduation
    return :grades if row_source == :third_grade || row_source == :eighth_grade
    return :testing if row_source == :math || row_source == :reading || row_source == :writing
    return :median if row_source == :median_household_income
    return :poverty_lunch if row_source == :children_in_poverty || row_source == :free_or_reduced_price_lunch
    return :title_i if row_source == :title_i
  end

  def self.clean_enrollment_data(row)
    standard_clean(row)
  end

  def self.clean_grades(row)
    standard_clean(row)
  end

  def self.clean_testing(row)
    standard_clean(row)
  end

  def self.clean_median_income(row)
    row[:location] = row[:location].upcase
    row[:data] = row[:data].to_i
    row
  end

  def self.clean_title_i(row)
    standard_clean(row)
  end

  def self.clean_poverty_and_lunch(row)
    row[:location] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    if row[:dataformat] == "Percent"
      row[:data] = row[:data].to_f.round(3)
    else
      row[:data] = row[:data].to_i
    end
    row
  end

  def self.standard_clean(row)
    row[:location] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    row[:data] = row[:data].to_f.round(3)
    row
  end

end
