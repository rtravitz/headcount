class Enrollment
  attr_accessor :participation
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    @information = Hash.new
    organize_data(data[:data])
  end

  def organize_data(data)
    data.each do |row|
      if @information[row[:source]]
        @information[row[:source]][row[:timeframe].to_i] = row[:data].to_f
      else
        @information[row[:source]] = {row[:timeframe].to_i => row[:data].to_f}
      end
    end
  end

  def kindergarten_participation_by_year
    @information.each do |year, rate|
      @information[year] = rate.to_s[0..4].to_f
    end
    @information
  end

  def kindergarten_participation_in_year(year)
    if @information[year].nil?
      nil
    else
      @information[year].to_s[0..4].to_f
    end
  end

end
