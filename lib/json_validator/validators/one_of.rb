module JsonValidator
  module Validators
    module OneOf
      extend self
      extend Validator

      type :any

      def validate(schema, fragment, record)
        fragment['oneOf'].count {|one_of_fragment| JsonValidator.validate(schema, one_of_fragment, record)} == 1
      end
    end
  end
end
