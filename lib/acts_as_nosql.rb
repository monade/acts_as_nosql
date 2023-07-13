# frozen_string_literal: true

require 'active_record'

# ActsAsNosql
#
# This gem allows to handle JSON and JSONB fields as if they are proper
# database columns, handling default values, type casting and simplifying
# validation.
# This module is the main entry point for the gem.
module ActsAsNosql
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  class_methods do
    attr_accessor :_acts_as_nosql_options

    def acts_as_nosql(field_name: nil)
      @_acts_as_nosql_options = { field_name: field_name }

      include ActsAsNosql::Attributes
    end

    def _acts_as_nosql_options
      @_acts_as_nosql_options
    end
  end

  autoload :Attribute
  autoload :Attributes
  autoload :Querying
end

ActiveRecord::Base.include ActsAsNosql
ActiveRecord::Relation.prepend(ActsAsNosql::Querying)
