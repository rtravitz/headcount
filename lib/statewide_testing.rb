require_relative 'organizer'

class StatewideTesting
  include Organizer

  attr_reader :name, :information

  def initialize(data)
    binding.pry
    @name = data[:name]
    @information = data
  end

end
