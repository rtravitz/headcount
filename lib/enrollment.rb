class Enrollment
  attr_reader :name

  def initialize(information)
    @name = information[:name]
    @kindergarten_participation = information[:kindergarten_participation]
  end

  def kindergarten_participation
    @kindergarten_participation.each do |year, rate|
      @kindergarten_participation[year] = rate.to_s[0..4].to_f
    end
    @kindergarten_participation
  end

end
