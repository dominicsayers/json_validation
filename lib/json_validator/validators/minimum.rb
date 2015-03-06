module JsonValidator
  module Validators
    module Minimum
      extend self
      extend Validator

      type :number

      def validate(schema, record)
        if schema['exclusiveMinimum']
          schema['minimum'] < record
        else
          schema['minimum'] <= record
        end
      end
    end
  end
end
