module Organizer

  def self.organize_data(data)
    information = Hash.new
    data.each do |row|
      if information[row[:source]]
        information[row[:source]][row[:timeframe].to_i] = row[:data].to_f.round(3)
      else
        information[row[:source]] = {row[:timeframe].to_i => row[:data].to_f.round(3)}
      end
    end
    information[:name] = data.first[:location].upcase
    information
  end
end
