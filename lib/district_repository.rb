require_relative 'loader'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'

class DistrictRepository
  include Loader

  attr_reader :repository, :enrollment_repo

  def initialize
    @repository = Hash.new
    @enrollment_repo = EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
  end

  def load_data(path)
    paths = Loader.extract_paths(path)
    @enrollment_repo.load_data(paths[:enrollment]) unless paths[:enrollment].nil?
    @statewide_repo.load_data(paths[:statewide]) unless paths[:statewide].nil?
    create_districts(paths[:enrollment])
  end

  def create_districts(path)
    path[:enrollment].each do |level, file_path|
      contents = Loader.parse_csv(file_path)
      contents.each do |row|
        unless location_exists?(row[:location])
          @repository[row[:location].upcase] = District.new({name: row[:location].upcase}, self)
        end
      end
    end
  end

  def find_enrollment(name)
    @enrollment_repo.find_by_name(name)
  end

  def find_statewide_test(name)
    @statewide_repo.find_by_name(name)
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
