require_relative 'loader'
require_relative 'organizer'
require_relative 'statewide_test'

class StatewideTestRepository
  include Loader
  include Organizer

  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    grouped_data = Loader.load_data(path)
    grouped_data.each do |name, data|
      organized_data = Organizer.organize_statewide_testing_data(data)
      @repository[name.upcase] = StatewideTest.new(organized_data)
    end
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
