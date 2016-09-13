require 'csv'
require './lib/enrollment'

class EnrollmentRepository
  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    CSV.foreach path[:enrollment][:kindergarten], headers: true, header_converters: :symbol do |row|
      unless location_exists?(row[:location])
        @repository[row[:location].upcase] = Enrollment.new({name: row[:location].upcase, kindergarten_participation: row[:data]})
      end
    end
  end

  def location_exists?(location)
    @repository[location.upcase] ? true : false
  end

  def find_by_name(name)
    @repository[name]
  end
end
