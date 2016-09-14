require 'csv'

module Loader

  def self.load_data(path)
    path = kindergarten_path(path)
    CSV.open path, headers: true, header_converters: :symbol
  end

  def self.kindergarten_path(path)
    path[:enrollment][:kindergarten]
  end
end
