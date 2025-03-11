source 'https://rubygems.org'
gemspec

rails_version = ENV['CI_RAILS_VERSION'] || '>= 0.0'

gem 'activesupport', rails_version
gem 'activerecord', rails_version

if ['~> 8.0.0', '>= 0', '>= 0.0'].include?(rails_version)
  gem 'sqlite3', '~> 2'
else
  gem 'sqlite3', '~> 1.7.3'
end
gem 'pg' if ENV['ACTIVE_RECORD_ADAPTER'] == 'postgresql'
gem 'mysql2' if ENV['ACTIVE_RECORD_ADAPTER'] == 'mysql'
gem 'typeprof'
