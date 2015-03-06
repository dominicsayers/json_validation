module JsonValidator
  module Validators
    module Validator
      extend self

      def type(type=nil)
        if type.nil?
          @type
        else
          @type = type
        end
      end
    end
  end
end
