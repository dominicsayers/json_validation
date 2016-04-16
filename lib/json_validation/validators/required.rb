module JsonValidation
  module Validators
    class Required < Validator
      type :object

      def validate(record)
        schema['required'].all? {|element| record.has_key?(element)}
      end
    end
  end
end
