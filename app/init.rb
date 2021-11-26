# frozen_string_literal: true

%w[domain infrastructure presentation application].each do |folder|
  require_relative "#{folder}/init"
end
