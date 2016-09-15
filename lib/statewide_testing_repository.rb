require_relative 'loader'
require_relative 'organizer'
require_relative 'statewide_testing'
require 'pry'

class StatewideTestingRepository

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
      @repository[name.upcase] = StatewideTesting.new(data)
    end
  end

end
