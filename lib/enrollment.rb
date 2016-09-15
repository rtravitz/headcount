class Enrollment
  attr_accessor :information
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    @information = Hash.new
    organize_data(data[:data])
  end

  def organize_data(data)
    data.each do |row|
      if @information[row[:source]]
        @information[row[:source]][row[:timeframe].to_i] = row[:data].to_f.round(3)
      else
        @information[row[:source]] = {row[:timeframe].to_i => row[:data].to_f.round(3)}
      end
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

end
