require_relative 'organizer'

class StatewideTesting
  include Organizer

  attr_reader :name, :information

  def initialize(data)
    # @name = data[:name]
    @information = data
  end

end
