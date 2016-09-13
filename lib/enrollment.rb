class Enrollment
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation]
  end

  def kindergarten_participation
    @kindergarten_participation.each do |year, rate|
      @kindergarten_participation[year] = rate.to_s[0..4].to_f
    end
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    if @kindergarten_participation[year].nil?
      nil
    else
      @kindergarten_participation[year].to_s[0..4].to_f
    end
  end

end
