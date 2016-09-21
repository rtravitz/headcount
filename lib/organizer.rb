module Organizer

  def self.organize_enrollment_data(data)
    information = Hash.new
    data.each do |row|
      if information[row[:source]]
        information[row[:source]][row[:timeframe]] = row[:data]
      else
        information[row[:source]] = {row[:timeframe] => row[:data]}
      end
    end
    information[:name] = data.first[:location]
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
    organized[:free_or_reduced_price_lunch] = clean_lunch(organized)
    organized[:title_i] = clean_title_i(organized)
    organized
  end

  def self.group_by_file(data)
    grouped = data.group_by{|row| row[:source]}
    grouped[:name] = data.first[:location]
    grouped
  end

  def self.clean_median_income(data)
    return nil unless data[:median_household_income]
    collected = Hash.new
    data[:median_household_income].each do |row|
      years = row[:timeframe].split("-")
      years.map!{|year| year}
      collected[years] = row[:data].to_f
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

  def self.clean_lunch(data)
    return nil unless data[:free_or_reduced_price_lunch]
    collected = Hash.new
    data[:free_or_reduced_price_lunch].each do |row|
      next unless row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      year = row[:timeframe].to_i
      collected[year] = {row[:dataformat].downcase.to_sym => row[:data]} unless collected[year]
      collected[year][row[:dataformat].downcase.to_sym] = row[:data]
      collected[year][:total] = collected[year].delete(:number) if row[:dataformat] == "Number"
    end
    collected
  end

  def self.clean_title_i(data)
    return nil unless data[:title_i]
    collected = Hash.new
    data[:title_i].each do |row|
      collected[row[:timeframe]] = row[:data]
    end
    collected
  end

end
