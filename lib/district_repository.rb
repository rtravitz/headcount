require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :repository, :enrollment_repo

  def initialize
    @repository = Hash.new
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(path)
    @enrollment_repo.load_data(path)
    path = path[:enrollment][:kindergarten]
    CSV.foreach path, headers: true, header_converters: :symbol do |row|
      unless location_exists?(row[:location])
        @repository[row[:location].upcase] = District.new({name: row[:location].upcase})
      end
    end
    associate_enrollments_and_districts
  end

  def associate_enrollments_and_districts
    @repository.each do |name, district|
      district.enrollment = @enrollment_repo.find_by_name(name)
    end
  end

  def location_exists?(location)
    @repository[location.upcase] ? true : false
  end

  def find_by_name(name)
    @repository[name]
  end

  def find_all_matching(fragment)
   @repository.select do |name, district|
     district if name.include?(fragment.upcase)
   end.values
 end

end
