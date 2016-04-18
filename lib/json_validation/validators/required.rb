module JsonValidation
  module Validators
    class Required < Validator
      type :object

      def validate(value, value_path)
        schema['required'].all? {|element| value.has_key?(element)}
      end
    end
  end
end
