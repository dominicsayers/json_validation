module JsonValidation
  module Validators
    class Properties < Validator
      type :object

      def validate(record)
        schema['properties'].keys.all? {|key|
          if record[key]
            inner_validators[key].validate(record[key])
          else
            true
          end
        }
      end

      def validate_with_errors(record)
        schema['properties'].keys.map {|key|
          if record[key]
            inner_validators[key].validate_with_errors(record[key])
          else
            nil
          end
        }
      end

      def inner_validators
        @inner_validators ||= Hash[schema['properties'].map {|k, f|
          [k, build_validator(f, "properties/#{k}")]
        }]
      end
    end
  end
end
