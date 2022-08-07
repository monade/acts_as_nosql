require 'active_record'

module ActsAsNosql
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  class_methods do
    attr_accessor :_acts_as_nosql_options
    # cattr_accessor :_acts_as_nosql_options
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
