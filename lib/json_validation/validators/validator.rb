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

      attr_reader :schema

      def initialize(schema)
        @schema = schema
      end

      def schema_attribute
        class_name = self.class.name.split("::").last
        class_name[0].downcase + class_name[1..-1]
      end

      def validate_with_errors(value, value_path)
        if validate(value, value_path)
          nil
        else
          ValidationFailure.new(
            schema: schema,
            schema_uri: schema.uri,
            schema_attribute: schema_attribute,
            value: value,
            value_path: value_path.join("/"),
          )
        end
      end
    end
  end
end
