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
    grouped_data = Loader.load_data(path)
    grouped_data.each do |name, data|
      organized_data = Organizer.organize_data(data)
      @repository[name.upcase] = Enrollment.new(organized_data)
    end
  end

  def find_by_name(name)
    @repository[name]
  end
end
