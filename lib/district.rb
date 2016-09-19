require_relative './enrollment_repository'

class District
  attr_accessor :enrollment
  attr_reader :name

  def initialize(data, district_repository = nil)
    @name = data[:name]
    @dr = district_repository
  end

  def enrollment
    @dr.find_enrollment(@name)
  end

  def statewide_test
    @dr.find_statewide_test(@name)
  end

  def economic_profile
    @dr.find_economic_profile(@name)
  end
  
end
