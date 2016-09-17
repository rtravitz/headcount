require 'csv'

module Loader

  def self.load_data(path)
    all_data = get_all_data(path)
    group_data(all_data)
  end

  def self.parse_csv(path)
    CSV.open path, headers: true, header_converters: :symbol
  end

  def self.get_all_data(path)
    type = check_repo_type(path)
    result = path[type].map do |level, file|
      contents = parse_csv(file).map(&:to_h)
      contents.map do |row|
        row[:source] = level
        row
      end
    end
    result.flatten
  end

  def self.group_data(all_data)
    all_data.group_by{|item| item[:location]}
  end

  def self.check_repo_type(path)
    return :enrollment if path.has_key?(:enrollment)
    return :statewide_testing if path.has_key?(:statewide_testing)
    return :economic_profile if path.has_key?(:economic_profile)
  end

  def self.extract_paths(path)
    path[:enrollment] ? enrollment = {:enrollment => path[:enrollment]} : nil
    path[:statewide_testing] ? statewide = {:statewide_testing => path[:statewide_testing]} : nil
    path[:economic_profile] ? economic = {:economic_profile => path[:economic_profile]} : nil
    {enrollment: enrollment, statewide: statewide, economic: economic}
  end

end
