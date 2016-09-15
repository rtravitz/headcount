require 'csv'

module Loader

  def self.load_data(path)
    CSV.open path, headers: true, header_converters: :symbol
  end

end
