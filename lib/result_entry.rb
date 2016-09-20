class ResultEntry

  attr_reader :data

  def initialize(input)
    @data = input
  end

  def free_and_reduced_price_lunch_rate
    key_check(@data[:free_and_reduced_price_lunch_rate])
  end

  def children_in_poverty_rate
    key_check(@data[:children_in_poverty_rate])
  end

  def high_school_graduation_rate
    key_check(@data[:high_school_graduation_rate])
  end

  def median_household_income
    key_check(@data[:median_household_income])
  end

  def key_check(input)
    input ? input : nil
  end

end
