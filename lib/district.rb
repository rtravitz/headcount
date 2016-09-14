require_relative './enrollment_repository'

class District
  attr_accessor :enrollment
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    @enrollment = nil
  end
end
