# frozen_string_literal: true

%w[domain infrastructure controllers presentation].each do |folder|
  require_relative "#{folder}/init"
end
