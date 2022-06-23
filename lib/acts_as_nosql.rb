require 'active_record'

module ActsAsNosql
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  class_methods do
    cattr_accessor :_acts_as_nosql_options
    def acts_as_nosql(field_name:)
      self._acts_as_nosql_options = { field_name: field_name }

      include ActsAsNosql::Attributes
    end
  end

  autoload :Attributes
end

ActiveRecord::Base.include ActsAsNosql
