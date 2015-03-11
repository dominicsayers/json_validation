module JsonValidator
  module Validators
    module AnyOf
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        fragment['anyOf'].any? {|any_of_fragment| JsonValidator.validate(schema, any_of_fragment, record)}
      end
    end
  end
end
