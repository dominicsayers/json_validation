module JsonValidator
  module Validators
    module AllOf
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        fragment['allOf'].all? {|all_of_fragment| JsonValidator.validate(schema, all_of_fragment, record)}
      end
    end
  end
end
