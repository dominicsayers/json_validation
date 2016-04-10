module JsonValidator
  module Validators
    class Properties < Validator
      type :object

      def validate(record)
        fragment['properties'].keys.all? {|key|
          if record[key]
            inner_validators[key].validate(record[key])
          else
            true
          end
        }
      end

      def inner_validators
        @inner_validators ||= Hash[fragment['properties'].map {|k, f|
          [k, build_validator(f)]
        }]
      end
    end
  end
end
