require_relative 'enrollment'
require_relative 'loader'

class EnrollmentRepository
  include Loader

  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    all_data = get_all_data(path)
    grouped_data = all_data.group_by{|item| item[:location]}
    fill_enrollments(grouped_data)
  end

  def fill_enrollments(grouped_data)
    grouped_data.each do |name, data|
      @repository[name] = Enrollment.new({name: name, data: data})
    end
  end

  def get_all_data(path)
    result = path[:enrollment].map do |level, file|
      contents = Loader.load_data(path).map(&:to_h)
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
