require_relative 'enrollment'
require_relative 'loader'
require_relative 'organizer'

class EnrollmentRepository
  include Loader
  include Organizer

  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    all_data = get_all_data(path)
    grouped_data = all_data.group_by{|item| item[:location]}
    grouped_data.each do |name, data|
      organized_data = Organizer.organize_data(data)
      @repository[name.upcase] = Enrollment.new(organized_data)
    end
  end

  def get_all_data(path)
    result = path[:enrollment].map do |level, file|
      contents = Loader.load_data(file).map(&:to_h)
      contents.map do |row|
        row[:source] = level
        row
      end
    end
    result.flatten
  end

  def find_by_name(name)
    @repository[name]
  end
end
