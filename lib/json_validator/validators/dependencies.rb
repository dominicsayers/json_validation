module JsonValidator
  module Validators
    class Dependencies < Validator
      type :object

      def validate(record)
        fragment['dependencies'].all? {|property, v|
          case v
          when Hash
            dependency_fragment = v
            if record.has_key?(property)
              inner_validators[property].validate(record)
            else
              true
            end
          when Array
            property_set = v
            if record.has_key?(property)
              property_set.all? {|p| record.has_key?(p)}
            else
              true
            end
          else
            raise "Unexpected type for fragment['dependencies']['#{property}']"
          end
        }
      end

      def inner_validators
        @inner_validators ||= Hash[fragment['dependencies'].map {|k, f|
          [k, build_validator(f)]
        }]
      end
    end
  end
end
