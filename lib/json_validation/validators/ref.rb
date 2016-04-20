module JsonValidation
  module Validators
    class Ref < Validator
      type :any

      def validate(value, value_path)
        inner_validator.validate(value, value_path)
      end

      def inner_validator
        return @inner_validator if @inner_validator

        path = schema['$ref']
        reffed_uri = schema.resolution_scope.join(Addressable::URI.parse(path))
        reffed_schema = JsonValidation.load_schema(reffed_uri)
        @inner_validator = SchemaValidator.new(reffed_schema)
      end
    end
  end
end
