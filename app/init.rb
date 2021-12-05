# frozen_string_literal: true

%w[infrastructure presentation application].each do |folder|
  require_relative "#{folder}/init"
end
