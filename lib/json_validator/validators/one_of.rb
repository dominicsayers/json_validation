module JsonValidator
  module Validators
    module OneOf
      extend self
      extend Validator

      type :any

      def validate(schema, record)
        schema['oneOf'].count {|one_of_schema| JsonValidator.validate(one_of_schema, record)} == 1
      end
    end
  end
end
