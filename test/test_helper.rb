# frozen_string_literal: true

def enable_test_coverage
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
    add_coverage_groups
  end
end

def add_coverage_groups
  SimpleCov.add_group 'Models', 'app/models'
  SimpleCov.add_group 'Mailers', 'app/mailers'
  SimpleCov.add_group 'Controllers', 'app/controllers'
  SimpleCov.add_group 'Uploaders', 'app/uploaders'
  SimpleCov.add_group 'Helpers', 'app/helpers'
  SimpleCov.add_group 'Jobs', 'app/jobs'
  SimpleCov.add_group 'Services', 'app/services'
end

# TODO: This method is longer than recommended. Consider refactoring if possible.
enable_test_coverage if ENV['COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors) unless ENV['COVERAGE']

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

def headers(user, options = {})
  {
    Accept: 'application/json',
    'Content_Type' => 'application/json',
    'X-Auth-Token' => user.authentication_token,
    'X-Auth-Email' => user.email
  }.merge(options)
end

# parallelize_setup do
#   puts "New process is forked"
# end
