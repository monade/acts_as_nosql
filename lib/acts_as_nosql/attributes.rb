
module ActsAsNosql
  module Attributes
    extend ActiveSupport::Concern

    included do
      after_initialize :_acts_as_nosql_init_defaults
    end

    def _acts_as_nosql_init_defaults
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
          raise "Attribute #{name} already defined" if _acts_as_nosql_attribute_defined?(name)

          nosql_attributes[name] = ActsAsNosql::Attribute.new(name, type: type, default: default, path: path)
          _acts_as_nosql_define_attribute(nosql_attributes[name])
        end
      end

      def inherited(subclass)
        subclass._acts_as_nosql_options = self._acts_as_nosql_options.deep_dup
        super
      end

      def nosql_attributes
        self._acts_as_nosql_options[:attributes] ||= {}
      end

      def connection
        unless acts_as_nosql_conflicts_checked?
          @acts_as_nosql_conflicts_checked = true
          acts_as_nosql_check_conflicts!
        end
        super
      end

      def acts_as_nosql_conflicts_checked?
        @acts_as_nosql_conflicts_checked ||= false
      end

      def acts_as_nosql_check_conflicts!
        columns_map = columns.index_by(&:name)
        nosql_attributes.each do |name, attribute|
          raise "Attribute #{name} already defined" if columns_map[name.to_s]
        end
      end

      private

      def nosql_data_attribute
        @nosql_data_attribute ||= self._acts_as_nosql_options[:field_name]
      end

      def _acts_as_nosql_attribute_defined?(name)
        instance_methods.include?(name.to_sym) ||
          name.to_sym == nosql_data_attribute.to_sym
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
