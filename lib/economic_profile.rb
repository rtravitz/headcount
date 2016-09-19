require_relative 'organizer'
require_relative 'sanitizer'

class EconomicProfile

  include Organizer
  include Sanitizer

  attr_reader :name, :information

  def initialize(data)
    @name = data[:name]
    data.delete(:name)
    @information = data
  end

end
