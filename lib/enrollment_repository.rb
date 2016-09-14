require_relative './enrollment'
require_relative './loader'

class EnrollmentRepository
  include Loader

  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    contents = Loader.load_data(path)
    contents.each do |row|
      location = row[:location].upcase
      if location_exists?(location)
        @repository[location].participation[row[:timeframe].to_i] = row[:data].to_f
      else
        @repository[location] = Enrollment.new(
        { :name => location,
          :kindergarten_participation => {row[:timeframe].to_i => row[:data].to_f}})
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
