if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    coverage_dir  'metrics/coverage'
    add_filter    'test'
    command_name  'Mintest'
  end
end

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require "mocha/mini_test"

require_relative '../lib/app'

require 'stringio'
