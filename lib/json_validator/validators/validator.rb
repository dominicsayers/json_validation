module JsonValidator
  module Validators
    class Validator
      def self.type(type=nil)
        if type.nil?
          @type
        else
          @type = type
        end
      end

      attr_reader :fragment, :base_uri

      def initialize(fragment, base_uri)
        @fragment = fragment
        @base_uri = base_uri
      end

      def build_validator(fragment)
        JsonValidator.build_validator(fragment, base_uri)
      end

      def build_validator_with_new_base_uri(fragment, base_uri)
        JsonValidator.build_validator(fragment, base_uri)
      end
    end
  end
end
