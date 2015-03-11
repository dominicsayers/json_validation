module JsonValidator
  module Validators
    module Maximum
      extend self
      extend Validator

      type :number

      def validate(schema, fragment, record)
        if fragment['exclusiveMaximum']
          fragment['maximum'] > record
        else
          fragment['maximum'] >= record
        end
      end
    end
  end
end
