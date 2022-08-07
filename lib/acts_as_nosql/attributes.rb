
module ActsAsNosql
  module Attributes
    extend ActiveSupport::Concern

    included do
      after_initialize :_acts_as_nosql_init
    end

    def _acts_as_nosql_init
      self.class.nosql_attributes.each do |name, attribute|
        public_send("#{name}=", attribute.default.dup) if public_send(name).nil? && !attribute.default.nil?
      end
    end

    class_methods do
      def nosql_attrs(*names, type: nil, default: nil, path: nil)
        nosql_attr(*names, type: type, default: default, path: path)
      end

      def nosql_attr(*names, type: nil, default: nil, path: nil)
        attribute = self._acts_as_nosql_options[:field_name]

        names.each do |name|
          raise "Attribute #{name} already defined" if instance_methods.include?(name.to_sym) || name.to_sym == attribute.to_sym

          nosql_attributes[name] = ActsAsNosql::Attribute.new(name, type: type, default: default, path: path)
          _acts_as_nosql_define_attribute(nosql_attributes[name])
        end
      end

      def nosql_attributes
        self._acts_as_nosql_options[:attributes] ||= {}
      end

      private

      def nosql_data_attribute
        @nosql_data_attribute ||= self._acts_as_nosql_options[:field_name]
      end

      def _acts_as_nosql_define_attribute(nosql_attribute)
        attribute = nosql_data_attribute

        define_method(nosql_attribute.name) do
          nosql_attribute.read(self[attribute])
        end

        define_method("#{nosql_attribute.name}=") do |value|
          self[attribute] ||= {}
          nosql_attribute.write(self[attribute], value)
        end
      end
    end
  end
end
