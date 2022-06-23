
module ActsAsNosql
  module Attributes
    extend ActiveSupport::Concern

    class_methods do
      def nosql_attrs(*names, type: nil, default: nil)
        nosql_attr(*names, type: type, default: default)
      end

      def nosql_attr(*names, type: nil, default: nil)

        attribute = self._acts_as_nosql_options[:field_name]

        names.each do |name|
          raise "Attribute #{name} already defined" if instance_methods.include?(name.to_sym) || name.to_sym == attribute.to_sym

          type_caster = type ? "ActiveRecord::Type::#{type}".safe_constantize : nil

          define_method(name) do
            self[attribute]&.dig(name.to_s) || default
          end

          define_method("#{name}=") do |value|
            self[attribute] ||= {}
            self[attribute][name.to_s] = type_caster ? type_caster.new.cast(value) : value
          end
        end
      end
    end
  end
end
