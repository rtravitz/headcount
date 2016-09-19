require_relative 'loader'
require_relative 'organizer'
require_relative 'economic_profile'

class EconomicProfileRepository

  include Organizer
  include Loader

  attr_reader :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(path)
    grouped_data = Loader.load_data(path)
    grouped_data.each do |name, data|
      organized_data = Organizer.organize_economic_data(data)
      @repository[name.upcase] = EconomicProfile.new(organized_data)
    end
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
