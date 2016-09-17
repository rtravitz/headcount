require_relative 'organizer'
require_relative 'sanitizer'

class StatewideTest
  include Organizer
  include Sanitizer

  attr_reader :name, :information

  def initialize(data)
    @name = data[:name]
    data.delete(:name)
    @information = data
  end

  def proficient_by_grade(grade)
    Sanitizer.error?(grade_check(grade))
    data = @information[:third_grade]   if grade == 3
    data = @information[:eighth_grade]  if grade == 8
    grouped = data.group_by{|row| row[:timeframe]}
    format_data(grouped)
  end

  def proficient_by_race_or_ethnicity(race)
    Sanitizer.error?(race_check(race))
    subjects = [:math, :reading, :writing]
    if race_check(race)
      sorted = subjects.map do |subject|
        @information[subject].select do |row|
          row[:race_ethnicity].downcase == race.to_s
        end
      end.flatten
      grouped = sorted.group_by{|row| row[:timeframe]}
      format_data(grouped)
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    Sanitizer.error?((subject_check(subject) && grade_check(grade)))
    table = proficient_by_grade(grade)
    table[year][subject] == 0.0 ? "N/A" : table[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    Sanitizer.error?((subject_check(subject) && race_check(race)))
    table = proficient_by_race_or_ethnicity(race)
    table[year][subject] == 0.0 ? "N/A" : table[year][subject]
  end

  def format_data(grouped)
    tag = grouped.values.first.first.has_key?(:score) ? :score : :source
    final = Hash.new
    grouped.each do |year, dataset|
      sets = Hash.new
      dataset.each do |data_hash|
        sets[data_hash[tag].downcase.to_sym] = data_hash[:data].to_f.round(3)
      end
      final[year.to_i] = sets
    end
    final
  end

  def race_check(race)
    options = [ :asian, :black, :pacific_islander, :hispanic,
                :native_american, :two_or_more, :white  ]
    options.include?(race) ? true : false
  end

  def subject_check(subject)
    subjects = [:math, :reading, :writing]
    subjects.include?(subject) ? true : false
  end

  def grade_check(grade)
    [3, 8].include?(grade)
  end

end
