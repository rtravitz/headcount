require_relative 'organizer'

class StatewideTesting
  include Organizer

  attr_reader :name, :information

  def initialize(data)
    @name = data[:name]
    data.delete(:name)
    @information = data
  end

end
