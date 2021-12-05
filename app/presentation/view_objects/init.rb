# frozen_string_literal: true

require_relative 'decorators/init'

Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
