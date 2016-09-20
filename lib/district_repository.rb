require_relative 'loader'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository
  include Loader

  attr_reader :dr, :ecr

  def initialize
    @dr = Hash.new
    @er = EnrollmentRepository.new
    @str = StatewideTestRepository.new
    @ecr = EconomicProfileRepository.new
  end

  def load_data(path)
    paths = Loader.extract_paths(path)
    @er.load_data(paths[:enrollment]) unless paths[:enrollment].nil?
    @str.load_data(paths[:statewide]) unless paths[:statewide].nil?
    @ecr.load_data(paths[:economic]) unless paths[:economic].nil?
    create_districts(paths[:enrollment])
  end

  def create_districts(path)
    path[:enrollment].each do |level, file_path|
      contents = Loader.parse_csv(file_path)
      contents.each do |row|
        unless location_exists?(row[:location])
          @dr[row[:location].upcase] = District.new({name: row[:location].upcase}, self)
        end
      end
    end
  end

  def find_enrollment(name)
    @er.find_by_name(name)
  end

  def find_statewide_test(name)
    @str.find_by_name(name)
  end

  def find_economic_profile(name)
    @ecr.find_by_name(name)
  end

  def location_exists?(location)
    @dr[location.upcase] ? true : false
  end

  def find_by_name(name)
    @dr[name]
  end

  def find_all_matching(fragment)
   @dr.select do |name, district|
     district if name.include?(fragment.upcase)
   end.values
  end

end
