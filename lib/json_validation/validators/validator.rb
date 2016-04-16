module JsonValidation
  module Validators
    class Validator
      def self.type(type=nil)
        if type.nil?
          @type
        else
          @type = type
        end
      end

      attr_reader :schema, :base_uri

      def initialize(schema, base_uri)
        @schema = schema
        @base_uri = base_uri
      end

      def build_validator(schema)
        JsonValidation.build_validator(schema, base_uri)
      end

      def build_validator_with_new_base_uri(schema, base_uri)
        JsonValidation.build_validator(schema, base_uri)
      end
    end
  end
end
