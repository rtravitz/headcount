require_relative 'errors'

module Sanitizer

  def self.error?(condition)
    raise UnknownDataError unless condition
  end
  
end
