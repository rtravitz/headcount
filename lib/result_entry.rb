class ResultEntry

  attr_reader :data

  def initialize(input)
    @data = input
  end

  def name
    key_check(@data[:name])
  end

  def free_or_reduced_price_lunch_rate
    key_check(@data[:free_or_reduced_price_lunch])
  end

  def children_in_poverty_rate
    key_check(@data[:children_in_poverty])
  end

  def high_school_graduation_rate
    key_check(@data[:high_school_graduation])
  end

  def median_household_income
    key_check(@data[:median_household_income])
  end

  def key_check(input)
    input ? input : nil
  end

end
