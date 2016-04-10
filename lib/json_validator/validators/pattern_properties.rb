module JsonValidator
  module Validators
    class PatternProperties < Validator
      type :object

      def validate(record)
        fragment['patternProperties'].keys.all? {|pattern|
          rx = Regexp.new(pattern)
          record.select {|k, v| rx.match(k)}.all? {|k, v|
            inner_validators[pattern].validate(v)
          }
        }
      end

      def inner_validators
        @inner_validators ||= Hash[fragment['patternProperties'].map {|pattern, f|
          [pattern, build_validator(f)]
        }]
      end
    end
  end
end
