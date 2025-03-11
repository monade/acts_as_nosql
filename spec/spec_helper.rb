require 'logger'
require 'active_support'
require 'rspec'
require 'acts_as_nosql'
require 'active_record'

I18n.enforce_available_locales = false
RSpec::Expectations.configuration.warn_about_potential_false_positives = false

Dir[File.expand_path('support/*.rb', __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    Schema.create
  end

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
