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
    group_by_file(data)
  end

  def self.organize_economic_data(data)
    organized = group_by_file(data)
    organized[:median_household_income] = clean_median_income(organized)
    organized[:children_in_poverty] = clean_children_in_poverty(organized)
    organized[:free_or_reduced_price_lunch] = clean_free_or_reduced_price_lunch(organized)
    organized
  end

  def self.group_by_file(data)
    grouped = data.group_by{|row| row[:source]}
    grouped[:name] = data.first[:location].upcase
    grouped
  end

  def self.clean_median_income(data)
    collected = Hash.new
    data[:median_household_income].each do |row|
      years = row[:timeframe].split("-")
      collected[years] = row[:data]
    end
    collected
  end

  def self.clean_children_in_poverty(data)
    return nil unless data[:children_in_poverty]
    collected = Hash.new
    data[:children_in_poverty].each do |row|
      year = row[:timeframe]
      collected[year] = row[:data] if row[:dataformat] == "Percent"
    end
    collected
  end

  def self.clean_free_or_reduced_price_lunch(data)
    return nil unless data[:free_or_reduced_price_lunch]
    collected = Hash.new
    data[:free_or_reduced_price_lunch].each do |row|
      next unless row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      year = row[:timeframe]
      collected[year] = {row[:dataformat].downcase.to_sym => row[:data].to_f.round(3)} unless collected[year]
      collected[year][row[:dataformat].downcase.to_sym] = row[:data].to_f.round(3)
      collected[year][:total] = collected[year].delete(:number) if row[:dataformat] == "Number"
    end
    collected
  end



end
