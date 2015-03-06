module JsonValidator
  module Validators
    module Maximum
      extend self
      extend Validator

      type :number

      def validate(schema, record)
        if schema['exclusiveMaximum']
          schema['maximum'] > record
        else
          schema['maximum'] >= record
        end
      end
    end
  end
end
