class District
  attr_reader :name

  def initialize(information)
    @name = information[:name]
  end
end
