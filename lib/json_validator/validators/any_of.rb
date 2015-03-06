module JsonValidator
  module Validators
    module AnyOf
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        schema['anyOf'].any? {|any_of_schema| JsonValidator.validate(any_of_schema, record)}
      end
    end
  end
end
