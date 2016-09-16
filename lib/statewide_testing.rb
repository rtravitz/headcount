require_relative 'organizer'

class StatewideTesting
  include Organizer

  attr_reader :name, :information

  def initialize(data)
    @name = data[:name]
    data.delete(:name)
    @information = data
  end

  def proficient_by_grade(grade)
    data = @information[:third_grade]   if grade == 3
    data = @information[:eighth_grade]  if grade == 8
    grouped = data.group_by{|row| row[:timeframe]}
    final = {}
    grouped.each do |year, dataset|
      sets = {}
      dataset.each do |data_hash|
        sets[data_hash[:score].downcase.to_sym] = data_hash[:data].to_f.round(3)
      end
      final[year.to_i] = sets
    end
    final
  end


end
