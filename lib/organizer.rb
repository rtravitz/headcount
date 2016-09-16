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
        level = check_grade_depth(information, row)
        case level
        when 1
          information[row[:score].downcase.to_sym] = {row[:source] => {row[:timeframe] => row[:data]}}
        when 2
          information[row[:score].downcase.to_sym][row[:source]] = {row[:timeframe] => row[:data]}
        when 3
          information[row[:score].downcase_to_sym][row[:source]][row[:timeframe]] = row[:data]
        when 4
        end
      else
        level = check_race_depth(information, row)
        case level
        when 1
          information[row[:source]] = {row[:race_ethnicity] => {row[:timeframe] => row[:data]}}
        when 2
          information[row[:source]][row[:race_ethnicity]] = {row[:timeframe] => row[:data]}
        when 3
          information[row[:source]][row[:race_ethnicity]][row[:timeframe]] = row[:data]
        when 4
        end
      end
    end
    information[:name] = data.first[:location].upcase
    information
  end

  def self.third_or_eighth_grade?(row)
    row[:source] == :third_grade || row[:source] == :eighth_grade
  end

  def self.check_grade_depth(information, row)
    level = 1
    information[row[:score].downcase.to_sym] != nil ? level += 1 : level
    information[row[:score].downcase.to_sym][row[:source]] != nil ? level += 1 : level
    information[row[:score].downcase.to_sym][row[:source]][row[:timeframe]] != nil ? level += 1 : level
    level
    # return 4 if information[row[:score].downcase.to_sym][row[:source]][row[:timeframe]]
    # return 3 if information[row[:score].downcase.to_sym][row[:source]]
    # return 2 if information[row[:score].downcase.to_sym]
    # return 1
  end

  def self.check_race_depth(information, row)
    level = 1
    information[row[:source]] !=  nil ? level += 1 : level
    information[row[:source]][row[:race_ethnicity]] != nil ? level += 1 : level
    information[row[:source]][row[:race_ethnicity]][row[:timeframe]] != nil ? level += 1 : level
    level
    # return 4 if information[row[:source]][row[:race_ethnicity]][row[:timeframe]]
    # return 3 if information[row[:source]][row[:race_ethnicity]]
    # return 2 if information[row[:source]]
    # return 1
  end

end
