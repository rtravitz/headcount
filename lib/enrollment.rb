class Enrollment
  attr_accessor :information
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    data.delete(:name)
    @information = data
    check_kindergarten
  end

  def check_kindergarten
    if @information.keys.include?(:kindergarten_participation)
      @information[:kindergarten] = @information[:kindergarten_participation]
      @information.delete(:kindergarten_participation)
    end
  end

  def kindergarten_participation_by_year
    @information[:kindergarten].each do |year, rate|
      @information[:kindergarten][year] = rate.to_s[0..4].to_f
    end
    @information[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    if @information[:kindergarten][year].nil?
      nil
    else
      @information[:kindergarten][year].to_s[0..4].to_f
    end
  end

  def graduation_rate_by_year
    @information[:high_school_graduation].each do |year,rate|
      @information[:high_school_graduation][year] = rate.round(3)
    end
    @information[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    if @information[:high_school_graduation][year].nil?
      nil
    else
      @information[:high_school_graduation][year].round(3)
    end
  end
end
