class ResultSet

  def initialize(input)
    @set = input
  end

  def matching_districts
    @set[:matching_districts]
  end

  def statewide_average
    @set[:statewide_average]
  end

end
