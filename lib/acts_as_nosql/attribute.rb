
module ActsAsNosql
  class Attribute
    attr_reader :name, :type, :default, :path, :type_caster

    # @param [String, Symbol] name
    # @param [String, Symbol, nil] type
    # @param [Object, nil] default
    # @param [Array<String, Symbol>, nil] path
    def initialize(name, type: nil, default: nil, path: nil)
      @name = name.to_s
      @type = type
      @default = default
      @path = path&.map(&:to_s)
      @type_caster = type ? "ActiveRecord::Type::#{type}".safe_constantize : nil
    end

    def cast(value)
      type_caster ? type_caster.new.cast(value) : value
    end

    def read(attr)
      if path
        attr&.dig(*path)
      else
        attr&.dig(name)
      end
    end

    def write(attr, value)
      if path
        current = attr
        path[0...-1].each do |key|
          current[key] ||= {}
          current = current[key]
        end
        current[path.last] = cast(value)
      else
        attr[name] = cast(value)
      end
    end
  end
end
