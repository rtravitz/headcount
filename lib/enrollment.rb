class Enrollment
  attr_accessor :participation
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    @participation = Hash.new
  end

  def kindergarten_participation
    @participation.each do |year, rate|
      @participation[year] = rate.to_s[0..4].to_f
    end
    @participation
  end

  def kindergarten_participation_in_year(year)
    if @participation[year].nil?
      nil
    else
      @participation[year].to_s[0..4].to_f
    end
  end

end
