# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'acts_as_nosql/version'

Gem::Specification.new do |s|
  s.name        = 'acts_as_nosql'
  s.version     = ActsAsNosql::VERSION
  s.date        = '2022-06-23'
  s.summary     = 'Use JSON columns as real activerecord attributes'
  s.description = 'It allows to handle JSON and JSONB fields as if they are proper database columns, handling default values, type casting and easier validation.'
  s.authors     = ['Mònade']
  s.email       = 'team@monade.io'
  s.files = Dir['lib/**/*']
  s.test_files = Dir['spec/**/*']
  s.required_ruby_version = '>= 2.7.0'
  s.homepage    = 'https://rubygems.org/gems/acts_as_nosql'
  s.license     = 'MIT'
  s.add_dependency 'actionpack', ['>= 5', '< 8']
  s.add_dependency 'activesupport', ['>= 5', '< 8']
  s.add_dependency 'activerecord', ['>= 5', '< 8']
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rubocop'
end
