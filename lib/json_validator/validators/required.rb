module JsonValidator
  module Validators
    class Required < Validator
      type :object

      def validate(record)
        fragment['required'].all? {|element| record.has_key?(element)}
      end
    end
  end
end
