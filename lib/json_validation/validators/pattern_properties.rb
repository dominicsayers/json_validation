module JsonValidation
  module Validators
    class PatternProperties < Validator
      type :object

      def validate(value, value_path)
        schema['patternProperties'].keys.all? {|pattern|
          rx = Regexp.new(pattern)
          value.select {|k, v| rx.match(k)}.all? {|k, v|
            inner_validators[pattern].validate(v, value_path + [k])
          }
        }
      end

      def validate_with_errors(value, value_path)
        schema['patternProperties'].keys.map {|pattern|
          rx = Regexp.new(pattern)
          value.select {|k, v| rx.match(k)}.map {|k, v|
            inner_validators[pattern].validate_with_errors(v, value_path + [k])
          }
        }
      end

      def inner_validators
        @inner_validators ||= Hash[schema['patternProperties'].map {|pattern, subschema|
          [pattern, SchemaValidator.new(subschema)]
        }]
      end
    end
  end
end
