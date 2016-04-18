module JsonValidation
  module Validators
    class Validator
      def self.type(type=nil)
        if type.nil?
          @type
        else
          @type = type
        end
      end

      attr_reader :schema, :uri, :base_uri

      def initialize(schema, uri, base_uri)
        @schema = schema
        @uri = uri
        @base_uri = base_uri
      end

      def attribute_name
        class_name = self.class.name.split("::").last
        class_name[0].downcase + class_name[1..-1]
      end

      def validate_with_errors(value, value_path)
        if validate(value, value_path)
          nil
        else
          ValidationFailure.new(
            schema: schema,
            schema_uri: uri,
            schema_attribute: attribute_name,
            value: value,
            value_path: value_path.join("/"),
          )
        end
      end

      def build_validator(schema, path_fragment)
        build_validator_with_new_base_uri(schema, path_fragment, base_uri)
      end

      def build_validator_with_new_base_uri(schema, path_fragment, base_uri)
        if uri[-1] == "/"
          new_uri = uri + path_fragment
        else
          new_uri = uri + "/" + path_fragment
        end

        JsonValidation.build_validator(schema, new_uri, base_uri)
      end
    end
  end
end
