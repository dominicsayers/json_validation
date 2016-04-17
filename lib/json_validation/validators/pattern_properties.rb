module JsonValidation
  module Validators
    class PatternProperties < Validator
      type :object

      def validate(record)
        schema['patternProperties'].keys.all? {|pattern|
          rx = Regexp.new(pattern)
          record.select {|k, v| rx.match(k)}.all? {|k, v|
            inner_validators[pattern].validate(v)
          }
        }
      end

      def validate_with_errors(record)
        schema['patternProperties'].keys.map {|pattern|
          rx = Regexp.new(pattern)
          record.select {|k, v| rx.match(k)}.map {|k, v|
            inner_validators[pattern].validate_with_errors(v)
          }
        }
      end

      def inner_validators
        @inner_validators ||= Hash[schema['patternProperties'].map {|pattern, f|
          [pattern, build_validator(f, "patternProperties/#{pattern}")]
        }]
      end
    end
  end
end
