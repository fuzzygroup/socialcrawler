require "codeclimate-test-reporter"
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
CodeClimate::TestReporter.start
SimpleCov.start
puts "Simple Coverage Started"


