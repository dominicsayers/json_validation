module JsonValidation
  module Validators
    class Ref < Validator
      type :any

      def validate(record)
        inner_validator.validate(record)
      end

      def inner_validator
        return @inner_validator if @inner_validator

        path = schema['$ref']
        reffed_uri = base_uri.join(Addressable::URI.parse(path))
        reffed_schema = JsonValidation.load_schema(reffed_uri)
        @inner_validator = build_validator_with_new_base_uri(reffed_schema, reffed_uri)
      end
    end
  end
end
