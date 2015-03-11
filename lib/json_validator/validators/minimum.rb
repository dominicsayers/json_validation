module JsonValidator
  module Validators
    module Minimum
      extend self
      extend Validator

      type :number

      def validate(schema, fragment, record)
        if fragment['exclusiveMinimum']
          fragment['minimum'] < record
        else
          fragment['minimum'] <= record
        end
      end
    end
  end
end
