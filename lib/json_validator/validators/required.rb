module JsonValidator
  module Validators
    module Required
      extend self
      extend Validator

      type :object

      def validate(schema, fragment, record)
        fragment['required'].all? {|element| record.has_key?(element)}
      end
    end
  end
end
