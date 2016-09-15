require_relative './enrollment_repository'

class District
  attr_accessor :enrollment
  attr_reader :name

  def initialize(data, district_repository)
    @name = data[:name]
    @dr = district_repository
  end

  def enrollment
    require "pry"; binding.pry
    @dr.find_enrollment(@name)
  end
end
