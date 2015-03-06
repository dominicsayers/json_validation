module JsonValidator
  module Validators
    module AllOf
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        schema['allOf'].all? {|all_of_schema| JsonValidator.validate(all_of_schema, record)}
      end
    end
  end
end
