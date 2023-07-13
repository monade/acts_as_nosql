# frozen_string_literal: true

module ActsAsNosql
  module Querying
    def where(*args)
      args, json_args = *extract_json_args(args)

      if json_args
        chain = _acts_as_nosql_parse_where(json_args)

        args.first.empty? ? chain : chain.where(*args)
      else
        super
      end
    end

    private

    def extract_json_args(args)
      return [args, nil] unless args.first.is_a?(Hash)
      return [args, nil] unless model._acts_as_nosql_options

      attrs = model._acts_as_nosql_options[:attributes]
      hash = args.first

      return [args, nil] if hash.keys.none? { |key| attrs.key?(key) }

      json_hash = {}
      nonjson_hash = {}

      hash.each do |key, value|
        if attrs.key?(key)
          json_hash[key] = value
        else
          nonjson_hash[key] = value
        end
      end

      [
        [nonjson_hash, args[1..-1]],
        json_hash
      ]
    end

    def _acts_as_nosql_parse_where(hash)
      hash.inject(self) do |chain, (key, value)|
        attr = model._acts_as_nosql_options[:attributes][key]
        chain.where(*build_sql_query(attr, value))
      end
    end

    def build_sql_query(attribute, value)
      field_name = model._acts_as_nosql_options[:field_name]
      ["#{quote_chain(attribute, field_name)} = ?", value]
    end

    def quote_chain(attribute, field_name)
      if connection.adapter_name == 'PostgreSQL'
        quote_chain_psql(attribute, field_name)
      else
        quote_chain_base(attribute, field_name)
      end
    end

    def quote_chain_base(attribute, field_name)
      base = quote_full_column(field_name)
      path = attribute.path || [attribute.name]
      "#{base}->>'$.#{path.join('.')}'"
    end

    def quote_chain_psql(attribute, field_name)
      base = quote_full_column(field_name)
      path = attribute.path
      if attribute.path
        "#{base}->#{path[0...-1].map { |e| "'#{e}'"}.join('->')}->>'#{path.last}'"
      else
        "#{base}->>'#{attribute.name}'"
      end
    end

    def quote_full_column(field_name)
      connection.quote_table_name(arel_table.table_alias || arel_table.table_name) +
        '.' +
        connection.quote_column_name(field_name)
    end
  end
end
