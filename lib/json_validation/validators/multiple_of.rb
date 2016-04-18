module JsonValidation
  module Validators
    class MultipleOf < Validator
      type :number

      def validate(value, value_path)
        BigDecimal.new(value.to_s) % BigDecimal.new(schema['multipleOf'].to_s) == 0
      end
    end
  end
end
