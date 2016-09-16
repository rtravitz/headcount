module Organizer

  def self.organize_enrollment_data(data)
    information = Hash.new
    data.each do |row|
      if information[row[:source]]
        information[row[:source]][row[:timeframe].to_i] = row[:data].to_f.round(3)
      else
        information[row[:source]] = {row[:timeframe].to_i => row[:data].to_f.round(3)}
      end
    end
    information[:name] = data.first[:location].upcase
    information
  end

  def self.check_kindergarten(information)
    information.delete(:name)
    if information.keys.include?(:kindergarten_participation)
      information[:kindergarten] = information[:kindergarten_participation]
      information.delete(:kindergarten_participation)
    end
    information
  end

  def self.organize_statewide_testing_data(data)
    information = Hash.new
    data.each do |row|
      if third_or_eighth_grade?(row)
        information[row[:score].downcase.to_sym] = {row[:source] => {row[:timeframe] => row[:data]}}
      else
        information[row[:source]] = {row[:race_ethnicity] => {row[:timeframe] => row[:data]}}
      end
    end
    information[:name] = data.first[:location].upcase
    information
  end

  def self.third_or_eighth_grade?(row)
    row[:source] == :third_grade || row[:source] == :eighth_grade
  end

end
